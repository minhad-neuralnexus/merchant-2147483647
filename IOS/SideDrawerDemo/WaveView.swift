//
//  WaveView.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 18/02/25.
//


import UIKit

class WaveView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.systemBlue.cgColor,
            UIColor.systemPurple.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        let waveShapeLayer = createWaveLayer()
        gradientLayer.mask = waveShapeLayer
        
        layer.addSublayer(gradientLayer)
    }
    
    private func createWaveLayer() -> CAShapeLayer {
        let path = UIBezierPath()
        let width = bounds.width
        let height = bounds.height
        
        path.move(to: CGPoint(x: 0, y: height * 0.5))
        
        for i in stride(from: 0, to: Int(width), by: 20) {
            let x = CGFloat(i)
            let y = height * 0.5 + sin(x / width * 2 * .pi) * height * 0.3
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        return shapeLayer
    }
}
