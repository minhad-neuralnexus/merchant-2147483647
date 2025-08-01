//
//  CustomInputView.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 09/04/25.
//

import UIKit
final class CustomInputView: UIView {
    
    // MARK: - Properties
    private let placeholder: String
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = placeholder
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var textField: UITextField = {
        let field = UITextField()
        field.font = .systemFont(ofSize: 16, weight: .regular)
        field.borderStyle = .none
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        field.placeholder = placeholder
        field.heightAnchor.constraint(equalToConstant: 45).isActive = true
        return field
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.alpha = 0 // Start with 0 alpha for animation
        label.isHidden = true
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .fill
        stack.distribution = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 12, left: 0, bottom: 12, right: 0)
        return stack
    }()
    
    // MARK: - Initialization
    init(placeholder: String) {
        self.placeholder = placeholder
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        // Add stack view
        addSubview(stackView)
        
        // Add arranged subviews to stack
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(errorLabel)
        
        // Constrain stack view to fill the custom view
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Public Methods
    func setText(_ text: String?) {
        textField.text = text
    }
    
    func setError(_ message: String?) {
        let shouldShow = !(message == nil || message?.isEmpty == true)
        
        if shouldShow {
            errorLabel.text = message
            if errorLabel.isHidden {
                // Prepare for showing
                errorLabel.isHidden = false
                errorLabel.alpha = 0
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.errorLabel.alpha = 1
                    self?.superview?.layoutIfNeeded() // Ensure superview updates layout
                }
            } else {
                // Just update text if already visible
                UIView.transition(with: errorLabel,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: { [weak self] in
                    self?.errorLabel.text = message
                },
                                  completion: nil)
            }
        } else if !errorLabel.isHidden {
            // Animate hiding
            UIView.animate(withDuration: 0.3,
                           animations: { [weak self] in
                self?.errorLabel.alpha = 0
                self?.superview?.layoutIfNeeded()
            },
                           completion: { [weak self] _ in
                self?.errorLabel.isHidden = true
                self?.errorLabel.text = nil
            })
        }
    }
    
    func getText() -> String? {
        return textField.text
    }
}
