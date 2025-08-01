import UIKit

class VoiceChatViewController: UIViewController {
    
    // UI Elements
    private let voiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Talk to Gemini", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let waveformView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Animation Layers
    private var barLayers: [CALayer] = []
    private let barCount = 5
    private let barWidth: CGFloat = 6
    private let barSpacing: CGFloat = 4
    
    // State
    private var isAnimating = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupWaveform()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(voiceButton)
        view.addSubview(waveformView)
        
        NSLayoutConstraint.activate([
            voiceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            voiceButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            waveformView.centerXAnchor.constraint(equalTo: voiceButton.centerXAnchor),
            waveformView.topAnchor.constraint(equalTo: voiceButton.bottomAnchor, constant: 20),
            waveformView.widthAnchor.constraint(equalToConstant: 60),
            waveformView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        voiceButton.addTarget(self, action: #selector(toggleVoiceChat), for: .touchUpInside)
    }
    
    private func setupWaveform() {
        let totalWidth = CGFloat(barCount) * barWidth + CGFloat(barCount - 1) * barSpacing
        let startX = (waveformView.bounds.width - totalWidth) / 2
        
        for i in 0..<barCount {
            let barLayer = CALayer()
            barLayer.frame = CGRect(x: startX + CGFloat(i) * (barWidth + barSpacing), y: 0, width: barWidth, height: 30)
            barLayer.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.7).cgColor
            barLayer.cornerRadius = barWidth / 2
            waveformView.layer.addSublayer(barLayer)
            barLayers.append(barLayer)
        }
    }
    
    // MARK: - Animations
    private func startWaveformAnimation() {
        for (index, bar) in barLayers.enumerated() {
            let animation = CABasicAnimation(keyPath: "bounds.size.height")
            animation.fromValue = 10
            animation.toValue = 30
            animation.duration = 0.4
            animation.autoreverses = true
            animation.repeatCount = .infinity
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.beginTime = CACurrentMediaTime() + Double(index) * 0.1 // Staggered effect
            bar.add(animation, forKey: "waveform\(index)")
        }
    }
    
    private func stopWaveformAnimation() {
        barLayers.forEach { $0.removeAllAnimations() }
    }
    
    // MARK: - Actions
    @objc private func toggleVoiceChat() {
        if isAnimating {
            stopWaveformAnimation()
            voiceButton.setTitle("Talk to Gemini", for: .normal)
            isAnimating = false
        } else {
            startWaveformAnimation()
            voiceButton.setTitle("Listening...", for: .normal)
            isAnimating = true
        }
    }
}

// AppDelegate for setup

