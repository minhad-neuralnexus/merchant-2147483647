//
//  AudioRecorderViewController.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 07/03/25.
//


import UIKit
import AVFoundation

class GeminiAudioVisualizerView: UIView {
    
    // Configuration
    private let particleCount = 12
    private let maxParticleSize: CGFloat = 16
    private let minParticleSize: CGFloat = 4
    private var particles: [CAShapeLayer] = []
    private var particlePositions: [CGPoint] = []
    private var audioLevel: CGFloat = 0.0
    
    // Colors - Gemini uses a multicolored gradient
    private let geminiColors: [UIColor] = [
        UIColor(red: 78/255, green: 131/255, blue: 253/255, alpha: 1), // Blue
        UIColor(red: 230/255, green: 109/255, blue: 87/255, alpha: 1),  // Red/Orange
        UIColor(red: 120/255, green: 194/255, blue: 86/255, alpha: 1),  // Green
        UIColor(red: 246/255, green: 187/255, blue: 66/255, alpha: 1)   // Yellow
    ]
    
    // Animation properties
    private var displayLink: CADisplayLink?
    private var animationStartTime: CFTimeInterval = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        layer.masksToBounds = true
        createParticles()
        
        // Set up display link for smooth animation
        displayLink = CADisplayLink(target: self, selector: #selector(updateAnimation))
        displayLink?.add(to: .current, forMode: .common)
        displayLink?.isPaused = true
        
        animationStartTime = CACurrentMediaTime()
    }
    
    private func createParticles() {
        // Remove existing particles if any
        particles.forEach { $0.removeFromSuperlayer() }
        particles = []
        particlePositions = []
        
        // Calculate center line
        let centerY = bounds.height / 2
        
        // Create particles distributed along the width
        for i in 0..<particleCount {
            let xPosition = bounds.width * CGFloat(i) / CGFloat(particleCount - 1)
            let position = CGPoint(x: xPosition, y: centerY)
            particlePositions.append(position)
            
            let particle = CAShapeLayer()
            particle.fillColor = geminiColors[i % geminiColors.count].cgColor
            particle.path = UIBezierPath(ovalIn: CGRect(x: -maxParticleSize/2, y: -maxParticleSize/2,
                                                        width: maxParticleSize, height: maxParticleSize)).cgPath
            particle.position = position
            
            layer.addSublayer(particle)
            particles.append(particle)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Adjust particle positions if view size changes
        createParticles()
    }
    
    func updateWithLevel(_ level: CGFloat) {
        // Clamp the level to prevent extreme values
        audioLevel = min(max(level, 0), 1)
        
        // Start animation if paused
        if displayLink?.isPaused == true {
            animationStartTime = CACurrentMediaTime()
            displayLink?.isPaused = false
        }
    }
    
    func stopAnimation() {
        displayLink?.isPaused = true
        
        // Reset all particles to center
        let centerY = bounds.height / 2
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3)
        for (i, particle) in particles.enumerated() {
            particle.position.y = centerY
            let size = minParticleSize
            particle.path = UIBezierPath(ovalIn: CGRect(x: -size/2, y: -size/2,
                                                        width: size, height: size)).cgPath
        }
        CATransaction.commit()
    }
    
    @objc private func updateAnimation() {
        let currentTime = CACurrentMediaTime()
        let elapsedTime = currentTime - animationStartTime
        
        // Center line of the view
        let centerY = bounds.height / 2
        
        // Update each particle
        for (i, particle) in particles.enumerated() {
            // Create wave-like motion with phase shift based on position
            let baseFrequency: CGFloat = 2.0
            let phaseShift = CGFloat(i) / CGFloat(particleCount) * .pi * 2
            
            // Combine multiple sine waves for more organic motion
            let wave1 = sin(baseFrequency * CGFloat(elapsedTime) + phaseShift)
            let wave2 = sin(baseFrequency * 1.5 * CGFloat(elapsedTime) + phaseShift * 0.8) * 0.5
            
            // Combine waves and scale by audio level
            let combinedWave = (wave1 + wave2) * audioLevel
            
            // Calculate vertical position
            let amplitude = bounds.height * 0.3
            let yOffset = combinedWave * amplitude
            
            // Update particle position with animation
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.1)
            particle.position.y = centerY + yOffset
            
            // Update particle size based on audio level and position in wave
            let sizeFactor = (audioLevel * 0.7) + 0.3 // Size factor between 0.3 and 1.0
            let waveImpact = (abs(combinedWave) * 0.5) + 0.5 // Impact is stronger at wave peaks
            let size = minParticleSize + (maxParticleSize - minParticleSize) * sizeFactor * waveImpact
            
            // Update the particle shape
            particle.path = UIBezierPath(ovalIn: CGRect(x: -size/2, y: -size/2,
                                                        width: size, height: size)).cgPath
            CATransaction.commit()
        }
    }
    
    deinit {
        displayLink?.invalidate()
    }
}

// Updated AudioRecorderViewController to use the new Gemini-style visualizer
class AudioRecorderViewController: UIViewController, AVAudioRecorderDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // UI Components
    private let micButton = UIButton()
    private let visualizerView = GeminiAudioVisualizerView()
    private let tableView = UITableView()
    
    // Audio recording properties
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordingSession: AVAudioSession!
    private var recordings: [URL] = []
    private var isRecording = false
    private var silenceTimer: Timer?
    private var meterTimer: Timer?
    
    // File management
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Audio Recorder"
        
        setupAudioSession()
        setupUI()
        loadRecordings()
    }
    
    // MARK: - Audio Setup
    
    private func setupAudioSession() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission { [weak self] allowed in
                DispatchQueue.main.async {
                    if !allowed {
                        self?.showRecordingNotAllowedAlert()
                    }
                }
            }
        } catch {
            print("Failed to set up recording session: \(error.localizedDescription)")
        }
    }
    
    private func showRecordingNotAllowedAlert() {
        let alert = UIAlertController(
            title: "Microphone Access Denied",
            message: "Please allow microphone access in Settings to use the recording feature.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        // Setup visualizer container with rounded corners
        let visualizerContainer = UIView()
        visualizerContainer.translatesAutoresizingMaskIntoConstraints = false
        visualizerContainer.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        visualizerContainer.layer.cornerRadius = 20
        view.addSubview(visualizerContainer)
        
        // Setup mic button - now using a floating style like Gemini
        micButton.translatesAutoresizingMaskIntoConstraints = false
        micButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        micButton.backgroundColor = .systemBlue
        micButton.tintColor = .white
        micButton.layer.cornerRadius = 30
        micButton.layer.shadowColor = UIColor.black.cgColor
        micButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        micButton.layer.shadowOpacity = 0.2
        micButton.layer.shadowRadius = 4
        micButton.addTarget(self, action: #selector(micButtonTapped), for: .touchUpInside)
        view.addSubview(micButton)
        
        // Setup visualizer view
        visualizerView.translatesAutoresizingMaskIntoConstraints = false
        visualizerContainer.addSubview(visualizerView)
        
        // Setup table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecordingCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            // Visualizer container constraints
            visualizerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            visualizerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            visualizerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            visualizerContainer.heightAnchor.constraint(equalToConstant: 100),
            
            // Visualizer view constraints
            visualizerView.topAnchor.constraint(equalTo: visualizerContainer.topAnchor, constant: 10),
            visualizerView.leadingAnchor.constraint(equalTo: visualizerContainer.leadingAnchor, constant: 10),
            visualizerView.trailingAnchor.constraint(equalTo: visualizerContainer.trailingAnchor, constant: -10),
            visualizerView.bottomAnchor.constraint(equalTo: visualizerContainer.bottomAnchor, constant: -10),
            
            // Mic button constraints
            micButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            micButton.topAnchor.constraint(equalTo: visualizerContainer.bottomAnchor, constant: 20),
            micButton.widthAnchor.constraint(equalToConstant: 60),
            micButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Table view constraints
            tableView.topAnchor.constraint(equalTo: micButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Recording Actions
    
    @objc private func micButtonTapped() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        // Create a new recording file name with timestamp
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let fileName = "recording_\(dateFormatter.string(from: Date())).wav"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        // Audio recording settings
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            
            // Update UI for recording state
            isRecording = true
            UIView.animate(withDuration: 0.3) {
                self.micButton.backgroundColor = .systemRed
                self.micButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
            
            // Start the meter timer for updating visualizer
            meterTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateMeter), userInfo: nil, repeats: true)
            
            // Reset silence detection
            resetSilenceTimer()
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    private func stopRecording() {
        // Stop recording and update UI
        audioRecorder?.stop()
        audioRecorder = nil
        isRecording = false
        
        // Stop visualizer animation
        visualizerView.stopAnimation()
        
        // Reset button appearance
        UIView.animate(withDuration: 0.3) {
            self.micButton.backgroundColor = .systemBlue
            self.micButton.transform = .identity
        }
        
        // Invalidate timers
        meterTimer?.invalidate()
        meterTimer = nil
        silenceTimer?.invalidate()
        silenceTimer = nil
        
        // Reload recordings list
        loadRecordings()
    }
    
    @objc private func updateMeter() {
        guard let recorder = audioRecorder, isRecording else { return }
        
        recorder.updateMeters()
        
        // Get the average power from the microphone
        let averagePower = recorder.averagePower(forChannel: 0)
        // Convert dB scale to percentage (dB is negative, normalizing to 0-1 range)
        let level = min(1.0, max(0.0, (averagePower + 60) / 60))
        
        // Update visualizer with the audio level
        visualizerView.updateWithLevel(CGFloat(level))
        
        // Check for silence (low audio level)
        if level < 0.05 {
            resetSilenceTimer()
        }
    }
    
    private func resetSilenceTimer() {
        silenceTimer?.invalidate()
        silenceTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            // Stop recording after 5 seconds of silence
            self?.stopRecording()
        }
    }
    
    // MARK: - File Management
    
    private func loadRecordings() {
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            recordings = directoryContents.filter { $0.pathExtension == "wav" }
            recordings.sort { $0.lastPathComponent > $1.lastPathComponent }
            tableView.reloadData()
        } catch {
            print("Failed to load recordings: \(error.localizedDescription)")
        }
    }
    
    // MARK: - AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            print("Recording finished unsuccessfully")
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordingCell", for: indexPath)
        
        let recording = recordings[indexPath.row]
        let fileName = recording.lastPathComponent
        
        var content = cell.defaultContentConfiguration()
        content.text = fileName
        
        // Get creation date and file size if possible
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: recording.path)
            if let creationDate = attributes[.creationDate] as? Date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .short
                content.secondaryText = dateFormatter.string(from: creationDate)
            }
        } catch {
            content.secondaryText = "Unknown date"
        }
        
        cell.contentConfiguration = content
        
        // Add a card-like appearance to cells
        cell.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        cell.layer.cornerRadius = 12
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowOpacity = 0.1
        cell.layer.shadowRadius = 3
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    // Providing spacing between cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recordingURL = recordings[indexPath.row]
        playRecording(url: recordingURL)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recordingURL = recordings[indexPath.row]
            
            do {
                try FileManager.default.removeItem(at: recordingURL)
                recordings.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("Failed to delete recording: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Audio Playback
    
    private func playRecording(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
        } catch {
            print("Failed to play recording: \(error.localizedDescription)")
        }
    }
}
