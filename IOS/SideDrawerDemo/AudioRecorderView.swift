//
//  AudioRecorderView.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 12/03/25.
//


import UIKit
import AVFoundation
/*
class AudioRecorderView: UIView {
    
    // MARK: - UI Components
    private let recordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 30
        button.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let recordingIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00,0"
        label.textColor = .darkGray
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let cancelLabel: UILabel = {
        let label = UILabel()
        label.text = "Left - cancel"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let sliderTrack: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let lockIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "lock.fill"))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - Properties
    private var recordingSession: AVAudioSession?
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    private var recordingDuration: TimeInterval = 0
    private var startLocation: CGPoint?
    private var isRecording = false
    private var isLocked = false
    private var recordingURL: URL?
    
    // Delegates and callbacks
    var onRecordingFinished: ((URL) -> Void)?
    var onRecordingCancelled: (() -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupGestures()
        setupAudioSession()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupGestures()
        setupAudioSession()
    }
    
    // MARK: - Setup
    private func setupViews() {
        // Background setup
        backgroundColor = .white
        layer.cornerRadius = 25
        layer.masksToBounds = true
        
        // Add and layout subviews
        addSubview(sliderTrack)
        sliderTrack.addSubview(recordingIndicator)
        sliderTrack.addSubview(timerLabel)
        sliderTrack.addSubview(cancelLabel)
        addSubview(recordButton)
        addSubview(lockIconImageView)
        
        // Apply constraints
        sliderTrack.translatesAutoresizingMaskIntoConstraints = false
        recordingIndicator.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        cancelLabel.translatesAutoresizingMaskIntoConstraints = false
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        lockIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sliderTrack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            sliderTrack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            sliderTrack.centerYAnchor.constraint(equalTo: centerYAnchor),
            sliderTrack.heightAnchor.constraint(equalToConstant: 40),
            
            recordingIndicator.leadingAnchor.constraint(equalTo: sliderTrack.leadingAnchor, constant: 10),
            recordingIndicator.centerYAnchor.constraint(equalTo: sliderTrack.centerYAnchor),
            recordingIndicator.widthAnchor.constraint(equalToConstant: 10),
            recordingIndicator.heightAnchor.constraint(equalToConstant: 10),
            
            timerLabel.leadingAnchor.constraint(equalTo: recordingIndicator.trailingAnchor, constant: 10),
            timerLabel.centerYAnchor.constraint(equalTo: sliderTrack.centerYAnchor),
            
            cancelLabel.leadingAnchor.constraint(equalTo: timerLabel.trailingAnchor, constant: 15),
            cancelLabel.centerYAnchor.constraint(equalTo: sliderTrack.centerYAnchor),
            
            recordButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            recordButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            recordButton.widthAnchor.constraint(equalToConstant: 60),
            recordButton.heightAnchor.constraint(equalToConstant: 60),
            
            lockIconImageView.centerXAnchor.constraint(equalTo: recordButton.centerXAnchor),
            lockIconImageView.bottomAnchor.constraint(equalTo: recordButton.topAnchor, constant: -15),
            lockIconImageView.widthAnchor.constraint(equalToConstant: 20),
            lockIconImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupGestures() {
        // Long press for record/stop
//        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
//        longPressGesture.minimumPressDuration = 0.1 // Almost immediate
//        recordButton.addGestureRecognizer(longPressGesture)
        
        // Pan gesture for slide-to-cancel and swipe-up-to-lock
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        recordButton.addGestureRecognizer(panGesture)
        
        // Tap gesture for quick record/stop when locked
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        recordButton.addGestureRecognizer(tapGesture)
    }
    
    private func setupAudioSession() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession?.setCategory(.playAndRecord, mode: .default)
            try recordingSession?.setActive(true)
            
            recordingSession?.requestRecordPermission { [weak self] allowed in
                if !allowed {
                    print("Recording permission denied")
                }
            }
        } catch {
            print("Failed to set up recording session: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Gesture Handlers
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            if !isRecording && !isLocked {
                startRecording()
            }
        case .ended, .cancelled:
            if isRecording && !isLocked {
                stopRecording()
            }
        default:
            break
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard isRecording else { return }
        
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .began:
            startLocation = gesture.location(in: self)
        case .changed:
            // Swipe up to lock
            if translation.y < -50 && !isLocked {
                lockRecording()
                return
            }
            
            // Slide left to cancel
            if translation.x < -100 && !isLocked {
                cancelRecording()
                return
            }
        default:
            break
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        if isLocked && isRecording {
            stopRecording()
            isLocked = false
            lockIconImageView.isHidden = true
        } else if !isRecording {
            startRecording()
        }
    }
    
    // MARK: - Recording Functions
    private func startRecording() {
        // Create recording URL
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("\(Date().timeIntervalSince1970).m4a")
        recordingURL = audioFilename
        
        // Recording settings
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            
            // Update UI
            isRecording = true
            recordButton.backgroundColor = .systemRed
            animateRecordingIndicator()
            startTimer()
            
        } catch {
            print("Could not start recording: \(error.localizedDescription)")
        }
    }
    
    private func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        recordingIndicator.layer.removeAllAnimations()
        timer?.invalidate()
        recordButton.backgroundColor = .systemPurple
        
        if let url = recordingURL {
            onRecordingFinished?(url)
        }
        
        // Reset state
        recordingDuration = 0
        timerLabel.text = "0:00,0"
    }
    
    private func cancelRecording() {
        audioRecorder?.stop()
        audioRecorder?.deleteRecording()
        isRecording = false
        recordingIndicator.layer.removeAllAnimations()
        timer?.invalidate()
        recordButton.backgroundColor = .systemPurple
        
        onRecordingCancelled?()
        
        // Reset state
        recordingDuration = 0
        timerLabel.text = "0:00,0"
    }
    
    private func lockRecording() {
        isLocked = true
        lockIconImageView.isHidden = false
        
        // Animate lock confirmation
        UIView.animate(withDuration: 0.3, animations: {
            self.lockIconImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.lockIconImageView.transform = .identity
            }
        }
    }
    
    // MARK: - Helper Methods
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.recordingDuration += 0.1
            self.updateTimerLabel()
        }
    }
    
    private func updateTimerLabel() {
        let minutes = Int(recordingDuration) / 60
        let seconds = Int(recordingDuration) % 60
        let tenths = Int((recordingDuration - Double(Int(recordingDuration))) * 10)
        timerLabel.text = String(format: "%d:%02d,%d", minutes, seconds, tenths)
    }
    
    private func animateRecordingIndicator() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.recordingIndicator.alpha = 0.2
        })
    }
}
*/

class AudioRecorderView: UIView {
    
    // MARK: - UI Components
    private let recordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 30
        button.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let recordingIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00,0"
        label.textColor = .darkGray
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let cancelLabel: UILabel = {
        let label = UILabel()
        label.text = "Left - cancel"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let sliderTrack: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let lockIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "lock.fill"))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - Properties
    private var recordingSession: AVAudioSession?
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    private var recordingDuration: TimeInterval = 0
    private var buttonOriginalCenter: CGPoint = .zero
    private var isRecording = false
    private var isLocked = false
    private var recordingURL: URL?
    
    // Delegates and callbacks
    var onRecordingFinished: ((URL) -> Void)?
    var onRecordingCancelled: (() -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupGestures()
        setupAudioSession()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupGestures()
        setupAudioSession()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Save the original position of the button for sliding
        if buttonOriginalCenter == .zero {
            buttonOriginalCenter = recordButton.center
        }
    }
    
    // MARK: - Setup
    private func setupViews() {
        // Background setup
        backgroundColor = .white
        layer.cornerRadius = 25
        layer.masksToBounds = true
        
        // Add and layout subviews
        addSubview(sliderTrack)
        sliderTrack.addSubview(recordingIndicator)
        sliderTrack.addSubview(timerLabel)
        sliderTrack.addSubview(cancelLabel)
        addSubview(recordButton)
        addSubview(lockIconImageView)
        
        // Apply constraints
        sliderTrack.translatesAutoresizingMaskIntoConstraints = false
        recordingIndicator.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        cancelLabel.translatesAutoresizingMaskIntoConstraints = false
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        lockIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sliderTrack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            sliderTrack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            sliderTrack.centerYAnchor.constraint(equalTo: centerYAnchor),
            sliderTrack.heightAnchor.constraint(equalToConstant: 40),
            
            recordingIndicator.leadingAnchor.constraint(equalTo: sliderTrack.leadingAnchor, constant: 10),
            recordingIndicator.centerYAnchor.constraint(equalTo: sliderTrack.centerYAnchor),
            recordingIndicator.widthAnchor.constraint(equalToConstant: 10),
            recordingIndicator.heightAnchor.constraint(equalToConstant: 10),
            
            timerLabel.leadingAnchor.constraint(equalTo: recordingIndicator.trailingAnchor, constant: 10),
            timerLabel.centerYAnchor.constraint(equalTo: sliderTrack.centerYAnchor),
            
            cancelLabel.leadingAnchor.constraint(equalTo: timerLabel.trailingAnchor, constant: 15),
            cancelLabel.centerYAnchor.constraint(equalTo: sliderTrack.centerYAnchor),
            
            recordButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            recordButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            recordButton.widthAnchor.constraint(equalToConstant: 60),
            recordButton.heightAnchor.constraint(equalToConstant: 60),
            
            lockIconImageView.centerXAnchor.constraint(equalTo: recordButton.centerXAnchor),
            lockIconImageView.bottomAnchor.constraint(equalTo: recordButton.topAnchor, constant: -15),
            lockIconImageView.widthAnchor.constraint(equalToConstant: 20),
            lockIconImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupGestures() {
        // Long press for record/stop
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.1 // Almost immediate
        recordButton.addGestureRecognizer(longPressGesture)
        
        // Tap gesture for quick record/stop when locked
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        recordButton.addGestureRecognizer(tapGesture)
    }
    
    private func setupAudioSession() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession?.setCategory(.playAndRecord, mode: .default)
            try recordingSession?.setActive(true)
            
            recordingSession?.requestRecordPermission { [weak self] allowed in
                if !allowed {
                    print("Recording permission denied")
                }
            }
        } catch {
            print("Failed to set up recording session: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Gesture Handlers
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            if !isRecording && !isLocked {
                startRecording()
            }
        case .changed:
            if isRecording && !isLocked {
                // Get horizontal movement
                let translation = gesture.location(in: self)
                let horizontalDistance = translation.x - buttonOriginalCenter.x
                
                // Swipe up to lock
                if translation.y < buttonOriginalCenter.y - 50 {
                    // Reset button position
                    UIView.animate(withDuration: 0.3) {
                        self.recordButton.center = self.buttonOriginalCenter
                    }
                    lockRecording()
                    return
                }
                
                // Slide left to cancel
                if horizontalDistance < -80 {
                    cancelRecording()
                    
                    // Reset button position with animation
                    UIView.animate(withDuration: 0.3) {
                        self.recordButton.center = self.buttonOriginalCenter
                    }
                    return
                }
                
                // Update button position (with constraint to prevent moving too far right)
                let newX = min(buttonOriginalCenter.x + horizontalDistance, buttonOriginalCenter.x)
                recordButton.center.x = newX
            }
        case .ended, .cancelled:
            if isRecording && !isLocked {
                // Animate back to original position
                UIView.animate(withDuration: 0.3) {
                    self.recordButton.center = self.buttonOriginalCenter
                }
                stopRecording()
            }
        default:
            break
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        if isLocked && isRecording {
            stopRecording()
            isLocked = false
            lockIconImageView.isHidden = true
        } else if !isRecording {
            startRecording()
        }
    }
    
    // MARK: - Recording Functions
    private func startRecording() {
        // Create recording URL
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("\(Date().timeIntervalSince1970).m4a")
        recordingURL = audioFilename
        
        // Recording settings
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            
            // Update UI
            isRecording = true
            recordButton.backgroundColor = .systemRed
            animateRecordingIndicator()
            startTimer()
            
        } catch {
            print("Could not start recording: \(error.localizedDescription)")
        }
    }
    
    private func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        recordingIndicator.layer.removeAllAnimations()
        timer?.invalidate()
        recordButton.backgroundColor = .systemPurple
        
        if let url = recordingURL {
            onRecordingFinished?(url)
        }
        
        // Reset state
        recordingDuration = 0
        timerLabel.text = "0:00,0"
    }
    
    private func cancelRecording() {
        audioRecorder?.stop()
        audioRecorder?.deleteRecording()
        isRecording = false
        recordingIndicator.layer.removeAllAnimations()
        timer?.invalidate()
        recordButton.backgroundColor = .systemPurple
        
        onRecordingCancelled?()
        
        // Reset state
        recordingDuration = 0
        timerLabel.text = "0:00,0"
    }
    
    private func lockRecording() {
        isLocked = true
        lockIconImageView.isHidden = false
        
        // Animate lock confirmation
        UIView.animate(withDuration: 0.3, animations: {
            self.lockIconImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.lockIconImageView.transform = .identity
            }
        }
    }
    
    // MARK: - Helper Methods
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.recordingDuration += 0.1
            self.updateTimerLabel()
        }
    }
    
    private func updateTimerLabel() {
        let minutes = Int(recordingDuration) / 60
        let seconds = Int(recordingDuration) % 60
        let tenths = Int((recordingDuration - Double(Int(recordingDuration))) * 10)
        timerLabel.text = String(format: "%d:%02d,%d", minutes, seconds, tenths)
    }
    
    private func animateRecordingIndicator() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.recordingIndicator.alpha = 0.2
        })
    }
}
