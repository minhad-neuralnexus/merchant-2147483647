//
//  DynamicInputViewDelegate.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 13/06/25.
//


import UIKit

protocol DynamicInputViewDelegate: AnyObject {
    func dynamicInputViewDidChangeText(_ inputView: DynamicInputView, text: String)
    func dynamicInputViewDidPressButton(at index: Int)
}

class DynamicInputView: UIView, UITextViewDelegate {
    
    weak var delegate: DynamicInputViewDelegate?
    
    private let maxTextViewHeight: CGFloat = 300
    private var textViewHeightConstraint: NSLayoutConstraint?
    private var waveButton: UIButton!
    private var sendButton: UIButton!
    
    private(set) lazy var textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.cornerRadius = 12
        tv.isScrollEnabled = false
        tv.delegate = self
        tv.backgroundColor = .clear
        return tv
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Type your message..."
        label.textColor = .tertiaryLabel
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    
    private lazy var buttonStack: UIStackView = {
        let leftButton1 = makeButton(systemName: "plus", tag: 0)
        let leftButton2 = makeButton(systemName: "slider.horizontal.3", tag: 1)
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        let rightButton1 = makeButton(systemName: "mic", tag: 2)
        waveButton = makeButton(systemName: "waveform", tag: 3)
        sendButton = makeButton(systemName: "paperplane.fill", tag: 4)
        sendButton.isHidden = true // hidden by default
        
        let stack = UIStackView(arrangedSubviews: [
            leftButton1,
            leftButton2,
            spacer,
            rightButton1,
            waveButton,
            sendButton
        ])

        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowColor = UIColor.label.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 24
        self.layer.masksToBounds = false
    }
    
 

    // MARK: - Setup
    
    private func setupView() {
        self.layer.cornerRadius = 20
        self.backgroundColor = .secondarySystemBackground
        
        // ✅ Add red shadow
      
        addSubview(textView)
        textView.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonStack)

        textView.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 40)
        textViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            buttonStack.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 12),
            buttonStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            buttonStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            buttonStack.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            buttonStack.heightAnchor.constraint(equalToConstant: 32),
            
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 5),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -5)
        ])
    }
    
    private func makeButton(systemName: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: systemName), for: .normal)
        button.tag = tag
        button.tintColor = .label
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }

    // MARK: - Actions
    
    @objc private func buttonTapped(_ sender: UIButton) {
        delegate?.dynamicInputViewDidPressButton(at: sender.tag)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        let finalHeight = min(estimatedSize.height, maxTextViewHeight)
        textView.isScrollEnabled = estimatedSize.height > maxTextViewHeight
        textViewHeightConstraint?.constant = finalHeight

        let hasText = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        waveButton.isHidden = hasText
        sendButton.isHidden = !hasText
        
        delegate?.dynamicInputViewDidChangeText(self, text: textView.text)
        layoutIfNeeded()
    }
}
