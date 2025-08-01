//
//  CommentViewController.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 08/03/25.
//

import UIKit

// MARK: - Comment Model
struct Comment {
    let id: String
    let username: String
    let profileImage: UIImage?
    let timeAgo: String
    let content: String
    let likes: Int
    let isLiked: Bool
    let replies: [Comment]?
    let hasHeartReaction: Bool
}

// MARK: - Comment Cell
class CommentCell: UITableViewCell {
    static let identifier = "CommentCell"
    
    // UI Elements
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let timeAgoLabel = UILabel()
    private let contentLabel = UILabel()
    private let replyButton = UIButton()
    private let likeButton = UIButton()
    private let likeCountLabel = UILabel()
    private let heartReactionImageView = UIImageView()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        selectionStyle = .none
        
        // Profile Image
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        
        // Username Label
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        contentView.addSubview(usernameLabel)
        
        // Time Ago Label
        timeAgoLabel.translatesAutoresizingMaskIntoConstraints = false
        timeAgoLabel.font = UIFont.systemFont(ofSize: 12)
        timeAgoLabel.textColor = .gray
        contentView.addSubview(timeAgoLabel)
        
        // Content Label
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.numberOfLines = 0
        contentView.addSubview(contentLabel)
        
        // Reply Button
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        replyButton.setTitle("Reply", for: .normal)
        replyButton.setTitleColor(.gray, for: .normal)
        replyButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(replyButton)
        
        // Like Button
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .gray
        contentView.addSubview(likeButton)
        
        // Like Count Label
        likeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        likeCountLabel.font = UIFont.systemFont(ofSize: 12)
        likeCountLabel.textColor = .gray
        contentView.addSubview(likeCountLabel)
        
        // Heart Reaction Image View
        heartReactionImageView.translatesAutoresizingMaskIntoConstraints = false
        heartReactionImageView.image = UIImage(systemName: "heart.fill")
        heartReactionImageView.tintColor = .systemPurple
        heartReactionImageView.isHidden = true
        contentView.addSubview(heartReactionImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Profile Image
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Username Label
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            
            // Time Ago Label
            timeAgoLabel.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: 8),
            timeAgoLabel.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor),
            
            // Content Label
            contentLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            contentLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Reply Button
            replyButton.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor),
            replyButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            replyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            // Like Button
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            likeButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            likeButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Like Count Label
            likeCountLabel.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -4),
            likeCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            
            // Heart Reaction Image View
            heartReactionImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -48),
            heartReactionImageView.centerYAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: -8),
            heartReactionImageView.widthAnchor.constraint(equalToConstant: 20),
            heartReactionImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    // MARK: - Configuration
    func configure(with comment: Comment) {
        profileImageView.image = comment.profileImage ?? UIImage(systemName: "person.circle.fill")
        usernameLabel.text = comment.username
        timeAgoLabel.text = comment.timeAgo
        contentLabel.text = comment.content
        
        // Configure like button state
        if comment.isLiked {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .systemRed
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .gray
        }
        
        // Show like count if needed
        if comment.likes > 0 {
            likeCountLabel.text = "\(comment.likes)"
            likeCountLabel.isHidden = false
        } else {
            likeCountLabel.isHidden = true
        }
        
        // Show heart reaction if needed
        heartReactionImageView.isHidden = !comment.hasHeartReaction
    }
}

// MARK: - Reply Cell
class ReplyCell: UITableViewCell {
    static let identifier = "ReplyCell"
    
    // UI Elements
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let timeAgoLabel = UILabel()
    private let contentLabel = UILabel()
    private let replyButton = UIButton()
    private let likeButton = UIButton()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        selectionStyle = .none
        
        // Profile Image
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 16
        profileImageView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        
        // Username Label
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        contentView.addSubview(usernameLabel)
        
        // Time Ago Label
        timeAgoLabel.translatesAutoresizingMaskIntoConstraints = false
        timeAgoLabel.font = UIFont.systemFont(ofSize: 12)
        timeAgoLabel.textColor = .gray
        contentView.addSubview(timeAgoLabel)
        
        // Content Label
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.numberOfLines = 0
        contentView.addSubview(contentLabel)
        
        // Reply Button
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        replyButton.setTitle("Reply", for: .normal)
        replyButton.setTitleColor(.gray, for: .normal)
        replyButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(replyButton)
        
        // Like Button
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .gray
        contentView.addSubview(likeButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Profile Image (smaller than parent comment)
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 56),
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            profileImageView.widthAnchor.constraint(equalToConstant: 32),
            profileImageView.heightAnchor.constraint(equalToConstant: 32),
            
            // Username Label
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            
            // Time Ago Label
            timeAgoLabel.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: 8),
            timeAgoLabel.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor),
            
            // Content Label
            contentLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            contentLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Reply Button
            replyButton.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor),
            replyButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            replyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Like Button
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            likeButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            likeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: - Configuration
    func configure(with comment: Comment) {
        profileImageView.image = comment.profileImage ?? UIImage(systemName: "person.circle.fill")
        usernameLabel.text = comment.username
        timeAgoLabel.text = comment.timeAgo
        contentLabel.text = comment.content
        
        // Parse mentions in content
        if let firstWord = comment.content.components(separatedBy: " ").first, firstWord.hasPrefix("@") {
            let attributedString = NSMutableAttributedString(string: comment.content)
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: (comment.content as NSString).range(of: firstWord))
            contentLabel.attributedText = attributedString
        } else {
            contentLabel.text = comment.content
        }
        
        // Configure like button state
        if comment.isLiked {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .systemRed
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .gray
        }
    }
}

// MARK: - Comments Controller
class CommentsViewController: UIViewController {
    
    private var recorderView: AudioRecorderView!
    // UI Elements
    private let tableView = UITableView()
    private let headerView = UIView()
    private let headerLabel = UILabel()
    private let commentInputView = UIView()
    private let commentTextField = UITextField()
    private let sendButton = UIButton()
    
    // Data
    private var comments: [Comment] = []
    private var expandedComments: Set<String> = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
        
        setupRecorderView()
    }
    
    private func setupRecorderView() {
        // Create and add the recorder view
        recorderView = AudioRecorderView(frame: .zero)
        view.addSubview(recorderView)
        
        recorderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recorderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            recorderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            recorderView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // Set up callbacks
        recorderView.onRecordingFinished = { [weak self] url in
            // Handle the recording URL
            print("Recording finished: \(url)")
        }
        
        recorderView.onRecordingCancelled = { [weak self] in
            // Handle cancellation
            print("Recording cancelled")
        }
    }
    
    // MARK: - Data Setup
    private func setupData() {
        // Sample data to match the image
        let jjaneCooperEmoji = "😍😍😍"
        let johnDoeEmoji = "😊😊😊"
        
        let replyToNoah = Comment(
            id: "reply1",
            username: "jjJaneCooper",
            profileImage: UIImage(systemName: "person.circle.fill"),
            timeAgo: "1 week ago",
            content: "@NoahPierre158 I agree, it's gorgeous! I like it very much! Especially the way the light falls in the photo, the buildings look marvelous \(jjaneCooperEmoji)",
            likes: 4,
            isLiked: false,
            replies: nil,
            hasHeartReaction: true
        )
        
        let replyToJane = Comment(
            id: "reply2",
            username: "JohnDoe211",
            profileImage: UIImage(systemName: "person.circle.fill"),
            timeAgo: "1 week ago",
            content: "@jjJaneCooper you were able to fully describe what I was thinking.",
            likes: 0,
            isLiked: false,
            replies: nil,
            hasHeartReaction: false
        )
        
        let replyThanks = Comment(
            id: "reply3",
            username: "jennyWilson1",
            profileImage: UIImage(systemName: "person.circle.fill"),
            timeAgo: "1 week ago",
            content: "@NoahPierre158 Thanks! 👍",
            likes: 0,
            isLiked: false,
            replies: nil,
            hasHeartReaction: false
        )
        
        // Main comments
        comments = [
            Comment(
                id: "comment1",
                username: "jjJaneCooper",
                profileImage: UIImage(systemName: "person.circle.fill"),
                timeAgo: "1 week ago",
                content: "It's so beautiful! I want to go there one day and see all these sights too",
                likes: 0,
                isLiked: false,
                replies: nil,
                hasHeartReaction: false
            ),
            Comment(
                id: "comment2",
                username: "NoahPierre158",
                profileImage: UIImage(systemName: "person.circle.fill"),
                timeAgo: "1 week ago",
                content: "Nice photos!",
                likes: 2,
                isLiked: false,
                replies: [replyToNoah, replyThanks],
                hasHeartReaction: false
            ),
            Comment(
                id: "comment3",
                username: "JohnDoe211",
                profileImage: UIImage(systemName: "person.circle.fill"),
                timeAgo: "1 week ago",
                content: "It's just perfect \(johnDoeEmoji)",
                likes: 0,
                isLiked: false,
                replies: nil,
                hasHeartReaction: false
            ),
            Comment(
                id: "comment4",
                username: "jennyWilson1",
                profileImage: UIImage(systemName: "person.circle.fill"),
                timeAgo: "1 week ago",
                content: "Thank you all for such lovely comments!",
                likes: 0,
                isLiked: false,
                replies: nil,
                hasHeartReaction: false
            )
        ]
        
        // Initially expand Noah's comment to show replies
        expandedComments.insert("comment2")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        // Header View
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .white
        view.addSubview(headerView)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Comments"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        headerLabel.textAlignment = .center
        headerView.addSubview(headerLabel)
        
        // Table View
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        tableView.register(ReplyCell.self, forCellReuseIdentifier: ReplyCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        
        // Comment Input View
        commentInputView.translatesAutoresizingMaskIntoConstraints = false
        commentInputView.backgroundColor = .white
        commentInputView.layer.borderWidth = 0.5
        commentInputView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(commentInputView)
        
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        commentTextField.placeholder = "Add a comment..."
        commentTextField.font = UIFont.systemFont(ofSize: 14)
        commentInputView.addSubview(commentTextField)
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        sendButton.tintColor = .systemBlue
        commentInputView.addSubview(sendButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Header View
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            // Header Label
            headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            // Table View
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: commentInputView.topAnchor),
            
            // Comment Input View
            commentInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commentInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            commentInputView.heightAnchor.constraint(equalToConstant: 60),
            
            // Comment Text Field
            commentTextField.leadingAnchor.constraint(equalTo: commentInputView.leadingAnchor, constant: 16),
            commentTextField.centerYAnchor.constraint(equalTo: commentInputView.centerYAnchor),
            commentTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            
            // Send Button
            sendButton.trailingAnchor.constraint(equalTo: commentInputView.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: commentInputView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 32),
            sendButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
}

// MARK: - TableView Delegate & DataSource
extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let comment = comments[section]
        if expandedComments.contains(comment.id) && comment.replies?.count ?? 0 > 0 {
            return 1 + (comment.replies?.count ?? 0)
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.section]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
            cell.configure(with: comment)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReplyCell.identifier, for: indexPath) as! ReplyCell
            if let reply = comment.replies?[indexPath.row - 1] {
                cell.configure(with: reply)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Toggle replies visibility when tapping on a comment
        if indexPath.row == 0 && comments[indexPath.section].replies?.count ?? 0 > 0 {
            let commentId = comments[indexPath.section].id
            if expandedComments.contains(commentId) {
                expandedComments.remove(commentId)
            } else {
                expandedComments.insert(commentId)
            }
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let comment = comments[section]
        
        if let replies = comment.replies, replies.count > 0 && !expandedComments.contains(comment.id) {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30))
            let button = UIButton(type: .system)
            button.frame = CGRect(x: 56, y: 5, width: 150, height: 20)
            button.setTitle("See \(replies.count) more replies", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.contentHorizontalAlignment = .left
            button.tag = section
            button.addTarget(self, action: #selector(showReplies(_:)), for: .touchUpInside)
            footerView.addSubview(button)
            return footerView
        } else if let replies = comment.replies, replies.count > 0 && expandedComments.contains(comment.id) {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30))
            let button = UIButton(type: .system)
            button.frame = CGRect(x: 56, y: 5, width: 150, height: 20)
            button.setTitle("Hide replies", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.contentHorizontalAlignment = .left
            button.tag = section
            button.addTarget(self, action: #selector(hideReplies(_:)), for: .touchUpInside)
            footerView.addSubview(button)
            return footerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let comment = comments[section]
        return comment.replies?.count ?? 0 > 0 ? 30 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 1))
        headerView.backgroundColor = .systemGray5
        return headerView
    }
    
    @objc private func showReplies(_ sender: UIButton) {
        let section = sender.tag
        let commentId = comments[section].id
        expandedComments.insert(commentId)
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    @objc private func hideReplies(_ sender: UIButton) {
        let section = sender.tag
        let commentId = comments[section].id
        expandedComments.remove(commentId)
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}
