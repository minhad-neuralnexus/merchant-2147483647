//
//  AudioVisualizerView.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 04/04/25.
//


import UIKit

class AudioVisualizerView: UIView {
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let gradientLayer = CAGradientLayer()
    
    private var heightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // Setup Gradient Layer
        gradientLayer.colors = [
            UIColor.systemBlue.withAlphaComponent(0.5).cgColor,
            UIColor.systemPurple.withAlphaComponent(0.3).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        layer.addSublayer(gradientLayer)
        
        // Add Blur Effect
        addSubview(blurEffectView)
        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Dynamic Height Constraint
        heightConstraint = blurEffectView.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    // Animate Height for Speech Effect
    func updateWaveHeight(to height: CGFloat) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.heightConstraint.constant = height
            self.layoutIfNeeded()
        })
    }
}
