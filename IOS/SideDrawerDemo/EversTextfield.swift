//
//  EversTextfield.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 17/02/25.
//

import Foundation
import UIKit

final class EversTextfield: UITextField {
    // MARK: - Properties
    
    private var floatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.alpha = 0
        return label
    }()
    
    private var borderLayer: CALayer = {
        let layer = CALayer()
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 8.0
        return layer
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        // Add border layer
        layer.addSublayer(borderLayer)
        
        // Add floating label
        addSubview(floatingLabel)
        floatingLabel.translatesAutoresizingMaskIntoConstraints = false
        floatingLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        floatingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        
        // Set up text field properties
        self.delegate = self
        
        // Observe text changes
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update border layer frame
        borderLayer.frame = bounds
        
        // Position floating label
        let labelSize = floatingLabel.sizeThatFits(CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))
    }
    
    // MARK: - Actions
    
    @objc private func textFieldDidChange() {
        if let text = self.text, !text.isEmpty {
            showFloatingLabel()
        } else {
            hideFloatingLabel()
        }
    }
    
    // MARK: - Floating Label Animation
    
    private func showFloatingLabel() {
        UIView.animate(withDuration: 0.3) {
            self.floatingLabel.alpha = 1
            self.floatingLabel.textColor = .darkGray
        }
    }
    
    private func hideFloatingLabel() {
        UIView.animate(withDuration: 0.3) {
            self.floatingLabel.alpha = 0
            self.floatingLabel.textColor = .lightGray
        }
    }
}

// MARK: - UITextFieldDelegate

extension EversTextfield: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if let text = textField.text, !text.isEmpty {
        self.floatingLabel.text = textField.placeholder
            showFloatingLabel()
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            hideFloatingLabel()
        }
    }
}
