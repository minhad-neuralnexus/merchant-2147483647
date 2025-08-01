//
//  CommentsViewController.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 15/02/25.
//

/*
import UIKit

import Foundation

struct Comment {
    let id: Int
    let username: String
    let message: String
    let timeAgo: String
    var replies: [Comment]
    var isExpanded: Bool = false
}


class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var comments: [Comment] = [
        Comment(id: 1, username: "NoahPierre158", message: "It's so beautiful! I want to go there one day and see all these sights too", timeAgo: "1 week ago", replies: []),
        Comment(id: 2, username: "jjJaneCooper", message: "I agree, it's gorgeous! Especially the way the light falls in the photo, the buildings look marvelous 😍😍", timeAgo: "1 week ago", replies: [
            Comment(id: 3, username: "JohnDoe211", message: "You were able to fully describe what I was thinking.", timeAgo: "1 week ago", replies: [])
        ]),
        Comment(id: 4, username: "jennyWilson1", message: "Thank you all for such lovely comments!", timeAgo: "1 week ago", replies: [])
    ]
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comments"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - UITableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let comment = comments[section]
        return comment.isExpanded ? (1 + comment.replies.count) : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        let comment = comments[indexPath.section]
        if indexPath.row == 0 {
            cell.configure(with: comment, isReply: false)
            cell.showHideButton.isHidden = comment.replies.isEmpty
            cell.showHideButton.setTitle(comment.isExpanded ? "Hide replies" : "Show replies", for: .normal)
            cell.showHideButtonAction = { [weak self] in
                self?.toggleReplies(section: indexPath.section)
            }
        } else {
            let reply = comment.replies[indexPath.row - 1]
            cell.configure(with: reply, isReply: true)
            cell.showHideButton.isHidden = true
        }
        
        return cell
    }
    
    func toggleReplies(section: Int) {
        comments[section].isExpanded.toggle()
        tableView.reloadSections(IndexSet(integer: section), with: .fade)
    }
}



class CommentCell: UITableViewCell {
    
    let usernameLabel = UILabel()
    let messageLabel = UILabel()
    let timeLabel = UILabel()
    let showHideButton = UIButton(type: .system)
    
    var showHideButtonAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [usernameLabel, messageLabel, timeLabel, showHideButton])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
        
        usernameLabel.font = .boldSystemFont(ofSize: 14)
        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.numberOfLines = 0
        timeLabel.font = .systemFont(ofSize: 12)
        timeLabel.textColor = .gray
        
        showHideButton.setTitleColor(.blue, for: .normal)
        showHideButton.addTarget(self, action: #selector(handleShowHideButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with comment: Comment, isReply: Bool) {
        usernameLabel.text = comment.username
        messageLabel.text = comment.message
        timeLabel.text = comment.timeAgo
        showHideButton.isHidden = true
        
        if isReply {
            contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
            contentView.frame.origin.x += 15
            frame.origin.x += 15
        } else {
            contentView.backgroundColor = .white
        }
    }
    
    @objc func handleShowHideButton() {
        showHideButtonAction?()
    }
}

#Preview {
    CommentsViewController()
}

*/
