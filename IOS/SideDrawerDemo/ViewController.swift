//
//  ViewController.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 23/01/25.
//

import UIKit
/*

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        
        
//        setValue(CustomTabBar(), forKey: "tabBar")
        
        let controller1 = UINavigationController(rootViewController: HomeController())
        controller1.view.backgroundColor = .systemBackground
        controller1.tabBarItem.title = "Home"
        
        let controller2 = HomeController()
        controller2.view.backgroundColor = .yellow
        controller2.tabBarItem.title = "search"
        
        let controller3 = HomeController()
        controller3.view.backgroundColor = .brown
        controller3.tabBarItem.title = "Profile"
        
        viewControllers = [controller1, controller2, controller3]
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         let tabBarHeight: CGFloat = 60
        
        tabBar.layer.cornerRadius = 16
        tabBar.layer.masksToBounds = false
        tabBar.layer.shadowColor = UIColor.label.cgColor
        tabBar.layer.shadowRadius = 10
        tabBar.layer.shadowOpacity = 0.2
        
        
        tabBar.backgroundColor = .systemBackground
        tabBar.barTintColor = .systemBackground
        tabBar.tintColor = .blue
        tabBar.unselectedItemTintColor = .gray
        
        // Adjust position to make it float
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) {
            
            let bottomPadding = window.safeAreaInsets.bottom
            tabBar.frame = CGRect(x: 10, y: window.frame.height - tabBarHeight - bottomPadding , width: window.frame.width - 20, height: tabBarHeight)
        }
        
        
    }
    
}



class CustomTabBar: UITabBar {

    private let tabBarHeight: CGFloat = 55  // Adjust height for floating effect

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = tabBarHeight // Set custom height
        return sizeThatFits
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Make the tab bar rounded
        layer.cornerRadius = 18//tabBarHeight / 2
        layer.masksToBounds = false

        // Add a shadow for floating effect
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 20

        // Adjust position to make it float
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) {
            
            let bottomPadding = window.safeAreaInsets.bottom
            frame = CGRect(x: 10, y: window.frame.height - tabBarHeight - bottomPadding , width: window.frame.width - 20, height: tabBarHeight)
        }

        // Set background color
        backgroundColor = .systemBackground
        barTintColor = .systemBackground
        tintColor = .blue
        unselectedItemTintColor = .gray
    }
}



*/

import UIKit
import AVFoundation

class ViewController: UIViewController {
    private let waveformView = WaveformView()
    private var timer: Timer?
    
    let visualizer = AudioVisualizerView()
    let customView = CustomInputView(placeholder: "FIRST NBAME")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        
        view.addSubview(customView)
        customView.backgroundColor = .secondarySystemBackground
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26).isActive = true
        customView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        customView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        
        let button = UIButton()
        button.setTitle("Toggle Error Mode", for: [])
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(toggleErrorLabel), for: .touchUpInside)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: customView.bottomAnchor, constant: 16).isActive = true
        
    }
    
    @objc private func toggleErrorLabel() {
        customView.setError("Errroe occured")
    }
    
    
    // Simulate speaking animation
    func simulateSpeaking() {
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            let randomHeight = CGFloat.random(in: 50...150)
            self.visualizer.updateWaveHeight(to: randomHeight)
        }
    }
}


/*
class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var waveformView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var transcriptionLabel: UILabel!
    
    var audioRecorder: AVAudioRecorder?
    var isRecording = false
    var timer: Timer?
    var speechRecognizer: SFSpeechRecognizer?
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    let button = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupAudioRecorder()
        //requestSpeechAuthorization()
        view.backgroundColor = .systemBackground
        
        /*
        button.setImage(UIImage(systemName: "microphone"), for: [])
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        button.layer.cornerRadius = 44 / 2
        
        button.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_ :))))
         */
        let voiceRecorderView = VoiceRecorderView(frame: CGRect(x: 0, y: view.bounds.height - 200, width: view.bounds.width, height: 150))
        view.addSubview(voiceRecorderView)
        
    }
    
    // MARK: - Handle Pan Gesture
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let button = gesture.view else { return }
        
        // Get the translation (movement) in the view's coordinate system
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began, .changed:
            // Move the button with the finger
            let newX = button.center.x + translation.x
            let newY = button.center.y //+ translation.y
            
            // Optional: Constrain movement (e.g., only allow left/right)
            // Remove newY if you only want horizontal movement
            button.center = CGPoint(x: newX, y: newY)
            
            // Reset translation to zero after applying it
            gesture.setTranslation(.zero, in: view)
            
        case .ended:
            // Optional: Add behavior when the swipe ends (e.g., snap back)
            print("Pan gesture ended at: \(button.center)")
            
        default:
            break
        }
    }
    
    func setupAudioRecorder() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilename = documentsPath.appendingPathComponent("recording.m4a")
            
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
        } catch {
            print("Error setting up audio recorder: \(error)")
        }
    }
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    print("Speech recognition authorized")
                case .denied:
                    print("Speech recognition denied")
                case .restricted:
                    print("Speech recognition restricted")
                case .notDetermined:
                    print("Speech recognition not determined")
                @unknown default:
                    print("Unknown authorization status")
                }
            }
        }
    }
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    func startRecording() {
        audioRecorder?.record()
        isRecording = true
        recordButton.setTitle("Stop Recording", for: .normal)
        
        // Start waveform animation
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.updateWaveform()
        }
        
        // Start speech recognition
        startSpeechRecognition()
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        recordButton.setTitle("Start Recording", for: .normal)
        
        // Stop waveform animation
        timer?.invalidate()
        timer = nil
        
        // Stop speech recognition
        stopSpeechRecognition()
    }
    
    func updateWaveform() {
        audioRecorder?.updateMeters()
        
        // Normalize the power level to a range of 0 to 1
        let power = pow(10, (audioRecorder?.averagePower(forChannel: 0) ?? -160) / 20)
        
        // Animate the waveform view
        UIView.animate(withDuration: 0.1) {
            self.waveformView.transform = CGAffineTransform(scaleX: 1.0, y: CGFloat(power))
        }
    }
    
    func startSpeechRecognition() {
        guard let recognizer = SFSpeechRecognizer(), recognizer.isAvailable else {
            print("Speech recognizer not available")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            print("Unable to create recognition request")
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.transcriptionLabel.text = result.bestTranscription.formattedString
                }
            }
            
            if error != nil {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error)")
        }
    }
    
    func stopSpeechRecognition() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Recording finished successfully.")
        } else {
            print("Recording failed.")
        }
    }
}
*/
