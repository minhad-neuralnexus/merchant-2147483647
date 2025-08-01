//
//  VoiceRecorderView.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 02/04/25.
//


import UIKit
import AVFoundation

class VoiceRecorderView: UIView {
    private var recordButton: UIButton!
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    private var isLocked = false
    private var isCancelled = false
    private var initialTouchPoint: CGPoint = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .lightGray
        
        // Initialize Record Button
        recordButton = UIButton(type: .custom)
        recordButton.setTitle("Hold to Record", for: .normal)
        recordButton.backgroundColor = .red
        recordButton.layer.cornerRadius = 30
        recordButton.addTarget(self, action: #selector(startRecording), for: .touchDown)
        recordButton.addTarget(self, action: #selector(stopRecording), for: .touchUpInside)
        recordButton.frame = CGRect(x: self.center.x - 50, y: self.bounds.height - 100, width: 100, height: 60)
        
        self.addSubview(recordButton)
        
        // Gesture Recognizers
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        recordButton.addGestureRecognizer(panGesture)
        
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { allowed in
                DispatchQueue.main.async {
                    if !allowed {
                        print("Recording permission denied.")
                    }
                }
            }
        } catch {
            print("Failed to setup audio session: \(error.localizedDescription)")
        }
    }
    
    @objc private func startRecording() {
        let audioFilename = FileManager.default.temporaryDirectory.appendingPathComponent("voiceMessage.m4a")
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            print("Recording started")
        } catch {
            print("Could not start recording: \(error.localizedDescription)")
        }
    }
    
    @objc private func stopRecording() {
        guard !isCancelled else {
            print("Recording cancelled")
            return
        }
        
        if isLocked {
            print("Recording locked, manual stop required")
        } else {
            audioRecorder?.stop()
            print("Recording stopped")
        }
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let touchPoint = gesture.location(in: self)
        
        switch gesture.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            let diffX = touchPoint.x - initialTouchPoint.x
            let diffY = touchPoint.y - initialTouchPoint.y
            
            if diffX < -50 { // Swipe left to cancel
                isCancelled = true
                stopRecording()
            } else if diffY < -50 { // Swipe up to lock
                isLocked = true
                print("Recording locked")
            }
        default:
            break
        }
    }
}

