import UIKit
import AVFoundation
import Speech

class VoiceRecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    // UI Elements
    let recordButton = UIButton(type: .system)
    private let voiceWaveView = VoiceWaveView()
    let transcriptionLabel = UILabel()
    
    // Audio Recording Properties
    var audioRecorder: AVAudioRecorder?
    var audioSession: AVAudioSession!
    var isRecording = false
    
    // Speech Recognition Properties
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    
    // Audio Engine for Speech Recognition
    let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupAudioSession()
        requestPermissions()
    }
    
    // MARK: - UI Setup
    
    func setupUI() {
        view.backgroundColor = .white
        
        voiceWaveView.frame = CGRect(x: 0, y: 50, width: 200, height: 50)
        voiceWaveView.center = view.center
        view.addSubview(voiceWaveView)
        
        // Start Animation
        voiceWaveView.startAnimating()
        
        // Record Button
        recordButton.setTitle("Record", for: .normal)
        recordButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        recordButton.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
        recordButton.backgroundColor = .systemBlue
        recordButton.layer.cornerRadius = 10
        recordButton.setTitleColor(.white, for: .normal)
        view.addSubview(recordButton)
        
        // Transcription Label
        transcriptionLabel.frame = CGRect(x: 50, y: 300, width: 300, height: 100)
        transcriptionLabel.textAlignment = .center
        transcriptionLabel.numberOfLines = 0
        transcriptionLabel.textColor = .black
        view.addSubview(transcriptionLabel)
        
        
//        let waveformView = WaveformView(frame: CGRect(x: 0, y: 200, width: UIScreen.main.bounds.width, height: 100))
//        view.addSubview(waveformView)
        let waveformView = MultiWaveformView(frame: CGRect(x: 0, y: 200, width: UIScreen.main.bounds.width, height: 150))
        view.addSubview(waveformView)
        
        
        
        let field = EversTextfield()
        field.placeholder = "Search here ..."
        field.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(field)
        field.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        field.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        field.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        field.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    
    // MARK: - Audio Session Setup
    
    func setupAudioSession() {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord	, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    // MARK: - Permissions
    
    func requestPermissions() {
        // Request microphone permission using AVAudioApplication (iOS 17+)
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission { [weak self] granted in
                if !granted {
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: "Microphone permission denied.")
                    }
                }
            }
        } else {
            // Fallback for older iOS versions
            audioSession.requestRecordPermission { [weak self] granted in
                if !granted {
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: "Microphone permission denied.")
                    }
                }
            }
        }
        
        // Request speech recognition permission
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus != .authorized {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Speech recognition permission denied.")
                }
            }
        }
    }
    
    // MARK: - Record Button Action
    
    @objc func recordButtonTapped() {
        if isRecording {
            stopRecording()
            recordButton.setTitle("Record", for: .normal)
            voiceWaveView.stopAnimating()
        } else {
            startRecording()
            recordButton.setTitle("Stop", for: .normal)
            voiceWaveView.startAnimating()
        }
        isRecording.toggle()
    }
    
    // MARK: - Start Recording
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            startTranscription()
        } catch {
            print("Could not start recording: \(error)")
        }
    }
    
    // MARK: - Stop Recording
    
    func stopRecording() {
        audioRecorder?.stop()
        stopTranscription()
    }
    
    // MARK: - Speech Recognition
    
    func startTranscription() {
        // Ensure the audio engine is stopped before starting
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.reset()
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            print("Unable to create recognition request")
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                self.transcriptionLabel.text = result.bestTranscription.formattedString
            }
            
            if error != nil {
                self.stopTranscription()
            }
        }
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine couldn't start: \(error)")
        }
    }
    
    func stopTranscription() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
    }
    
    // MARK: - Helper Functions
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
