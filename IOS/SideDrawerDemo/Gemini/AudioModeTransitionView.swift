//
//  AudioModeTransitionView.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 04/04/25.
//


import UIKit

class AudioModeTransitionView: UIView {
    
    private let inputIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mic.fill")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let waveformView: UIView = {
        let view = UIView()
        view.alpha = 0
        return view
    }()
    
    private var waveformLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(inputIconImageView)
        addSubview(waveformView)
        
        inputIconImageView.translatesAutoresizingMaskIntoConstraints = false
        waveformView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputIconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            inputIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            inputIconImageView.widthAnchor.constraint(equalToConstant: 40),
            inputIconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            waveformView.centerXAnchor.constraint(equalTo: centerXAnchor),
            waveformView.centerYAnchor.constraint(equalTo: centerYAnchor),
            waveformView.widthAnchor.constraint(equalToConstant: 80),
            waveformView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        setupWaveformLayer()
    }
    
    private func setupWaveformLayer() {
        let layer = CAShapeLayer()
        waveformLayer = layer
        waveformView.layer.addSublayer(layer)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.systemBlue.cgColor
        layer.lineWidth = 2
        layer.lineCap = .round
    }
    
    private func updateWaveform(data: [CGFloat]) {
        guard let layer = waveformLayer else { return }
        let path = UIBezierPath()
        let width = waveformView.bounds.width / CGFloat(data.count - 1)
        let height = waveformView.bounds.height / 2
        
        for (index, value) in data.enumerated() {
            let x = CGFloat(index) * width
            let y = height - (height * value)
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: height))
                path.addLine(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        layer.path = path.cgPath
    }
    
    func switchToAudioMode(animated: Bool = true) {
        let waveformData: [CGFloat] = [0.2, 0.5, 0.8, 0.6, 0.3, 0.1, 0.4, 0.7, 0.9, 0.5]
        updateWaveform(data: waveformData)
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.inputIconImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.inputIconImageView.alpha = 0
                self.waveformView.alpha = 1
                self.inputIconImageView.center = self.waveformView.center
            })
        } else {
            self.inputIconImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.inputIconImageView.alpha = 0
            self.waveformView.alpha = 1
        }
    }
    
    func switchToIconMode(animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.inputIconImageView.transform = .identity
                self.inputIconImageView.alpha = 1
                self.waveformView.alpha = 0
            })
        } else {
            self.inputIconImageView.transform = .identity
            self.inputIconImageView.alpha = 1
            self.waveformView.alpha = 0
        }
    }
}


