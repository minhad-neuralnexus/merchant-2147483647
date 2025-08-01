//
//  ChatController.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 12/06/25.
//

import UIKit



class ChatController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    private var expandedIndexSet: Set<Int> = []
    private let messages = [
        "hello",
        "Hi, how can I help you?",
        "This is a longer message that should cause the bubble to expand vertically and test the auto-layout behavior with multiple lines of text. Let’s see how it adjusts to the height properly!",
        "Short one.",
        "Here's a medium length message to test intermediate layout behavior."
    ]
    
    private let inputViewComponent = DynamicInputView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat View"
        view.backgroundColor = .systemBackground
        setupInputComponent()
//        setupTableView()
        
        
//        let inputView = CustomInputViewNew()
//        view.addSubview(inputView)
//        inputView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            inputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            inputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            inputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
        
    }
    
    private func setupInputComponent() {
        view.addSubview(inputViewComponent)
        inputViewComponent.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputViewComponent.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputViewComponent.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputViewComponent.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(ChatBubbleWithStackCell.self, forCellReuseIdentifier: ChatBubbleWithStackCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatBubbleWithStackCell.reuseIdentifier, for: indexPath) as? ChatBubbleWithStackCell else {
            return UITableViewCell()
        }
        let message = messages[indexPath.row]
        let isExpanded = expandedIndexSet.contains(indexPath.row)
        cell.configure(message: message, isExpanded: isExpanded)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if expandedIndexSet.contains(indexPath.row) {
            expandedIndexSet.remove(indexPath.row)
        } else {
            expandedIndexSet.insert(indexPath.row)
        }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}





class ChatBubbleWithStackCell: UITableViewCell {
    
    static let reuseIdentifier = "ChatBubbleWithStackCell"
    private var stackHeightConstraint: NSLayoutConstraint!
    
    private let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let reply = UIButton(type: .system)
        reply.setTitle("Reply", for: .normal)
        
        let forward = UIButton(type: .system)
        forward.setTitle("Forward", for: .normal)
        
        let delete = UIButton(type: .system)
        delete.setTitle("Delete", for: .normal)
        
        let stack = UIStackView(arrangedSubviews: [reply, forward, delete])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        contentView.addSubview(buttonStackView)
        stackHeightConstraint = buttonStackView.heightAnchor.constraint(equalToConstant: 40)

        NSLayoutConstraint.activate([
            // BubbleView constraints
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 16),
//            bubbleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // MessageLabel inside bubble
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -12),
            
            // StackView constraints
            buttonStackView.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 8),
            buttonStackView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor),
            stackHeightConstraint,
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(message: String, isExpanded: Bool) {
        messageLabel.text = message
        buttonStackView.isHidden = !isExpanded
        stackHeightConstraint.constant = isExpanded ? 40 : 0
    }
}




class CustomInputViewNew: UIView, UITextViewDelegate {
    
    private let maxTextViewHeight: CGFloat = 250
    
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.delegate = self
        tv.layer.cornerRadius = 10
        tv.layer.borderColor = UIColor.systemGray4.cgColor
        tv.layer.borderWidth = 1
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let buttonStack: UIStackView = {
        let attachButton = UIButton(type: .system)
        attachButton.setTitle("Attach", for: .normal)
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        
        let stack = UIStackView(arrangedSubviews: [attachButton, sendButton])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var textViewHeightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .systemTeal
        
        addSubview(textView)
        addSubview(buttonStack)
        
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 40)
        textViewHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            textViewHeightConstraint,
            
            buttonStack.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8),
            buttonStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            buttonStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            buttonStack.heightAnchor.constraint(equalToConstant: 44),
            buttonStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        let newHeight = min(estimatedSize.height, maxTextViewHeight)
        
        textView.isScrollEnabled = estimatedSize.height > maxTextViewHeight
        textViewHeightConstraint.constant = newHeight
        
        // Optional: animate height change
        UIView.animate(withDuration: 0.1) {
            self.layoutIfNeeded()
        }
    }
    
    // Optional: expose text content
    var messageText: String {
        return textView.text
    }
}
