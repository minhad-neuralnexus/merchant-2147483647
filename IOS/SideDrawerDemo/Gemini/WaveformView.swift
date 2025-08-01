//
//  WaveformView.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 04/04/25.
//


import UIKit
import AVFoundation



class WaveformView: UIView {
    // Configuration
    private let barWidth: CGFloat = 3.0
    private let spacing: CGFloat = 2.0
    private let minHeight: CGFloat = 2.0
    private let maxHeight: CGFloat = 40.0
    
    // Data
    private var amplitudes: [CGFloat] = []
    
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
        // Initialize with random amplitudes for testing
        updateWithRandomAmplitudes()
    }
    
    func updateWithRandomAmplitudes() {
        amplitudes.removeAll()
        let count = Int(bounds.width / (barWidth + spacing))
        
        // Create a mountain-like pattern
        for i in 0..<count {
            let position = CGFloat(i) / CGFloat(count)
            // Mountain shape (parabola)
            let mountain = 4 * position * (1 - position)
            // Add some randomness
            let randomFactor = CGFloat.random(in: 0.7...1.3)
            let amplitude = minHeight + (mountain * randomFactor * (maxHeight - minHeight))
            amplitudes.append(amplitude)
        }
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let centerY = bounds.height / 2
        let color = UIColor.systemBlue
        
        for (i, amplitude) in amplitudes.enumerated() {
            let x = CGFloat(i) * (barWidth + spacing)
            let barRect = CGRect(
                x: x,
                y: centerY - amplitude / 2,
                width: barWidth,
                height: amplitude
            )
            
            // Draw rounded rect
            let path = UIBezierPath(roundedRect: barRect, cornerRadius: barWidth/2)
            color.setFill()
            path.fill()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateWithRandomAmplitudes()
    }
}
