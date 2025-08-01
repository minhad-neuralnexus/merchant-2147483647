//
//  MultiWaveformView.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 18/02/25.
//


import UIKit

class MultiWaveformView: UIView {
    private var waveLayers: [CAShapeLayer] = []
    private var displayLink: CADisplayLink?
    private var phaseShifts: [CGFloat] = []
    private let waveCount = 5  // Number of overlapping waves

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupWaves()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWaves()
    }

    private func setupWaves() {
        let colors: [UIColor] = [
            UIColor.systemOrange.withAlphaComponent(0.8),
            UIColor.systemPink.withAlphaComponent(0.8),
            UIColor.systemPurple.withAlphaComponent(0.8),
            UIColor.systemRed.withAlphaComponent(0.8),
            UIColor.systemBlue.withAlphaComponent(0.8)
        ]

        for i in 0..<waveCount {
            let waveLayer = CAShapeLayer()
            waveLayer.strokeColor = colors[i % colors.count].cgColor
            waveLayer.fillColor = UIColor.clear.cgColor
            waveLayer.lineWidth = 2.0
            layer.addSublayer(waveLayer)
            waveLayers.append(waveLayer)
            phaseShifts.append(CGFloat(i) * 0.4) // Different phase shifts
        }

        displayLink = CADisplayLink(target: self, selector: #selector(updateWaves))
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc private func updateWaves() {
        for (index, waveLayer) in waveLayers.enumerated() {
            phaseShifts[index] += 0.05 // Increment phase for animation
            waveLayer.path = createWavePath(phaseShift: phaseShifts[index], amplitude: CGFloat(20 + index * 5)).cgPath
        }
    }

    private func createWavePath(phaseShift: CGFloat, amplitude: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        let width = bounds.width
        let height = bounds.height / 2
        let midY = bounds.midY
        let wavelength: CGFloat = width / 3 // Adjust for smoother curves

        path.move(to: CGPoint(x: 0, y: midY))

        for x in stride(from: 0, through: width, by: 1) {
            let y = amplitude * sin((x / wavelength) * .pi * 2 + phaseShift) + midY
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return path
    }

    deinit {
        displayLink?.invalidate()
    }
}
