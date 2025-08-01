//
//  Comment.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 15/02/25.
//

/*
import SwiftUI

struct Comment: Identifiable {
    let id = UUID()
    let username: String
    let timeAgo: String
    let text: String
    let replies: [Comment]?
    var isLiked: Bool = false
}

struct CommentsView: View {
    @State private var comments: [Comment] = [
        Comment(username: "NoahPierre158", timeAgo: "1 week ago", text: "It’s so beautiful! I want to go there one day and see all these sights too", replies: nil),
        Comment(username: "NoahPierre158", timeAgo: "1 week ago", text: "Nice photos!", replies: [
            Comment(username: "jjJaneCooper", timeAgo: "1 week ago", text: "@NoahPierre158 I agree, it’s gorgeous! I like it very much! Especially the way the light falls in the photo, the buildings look marvelous 😍😍😍", replies: [
                Comment(username: "JohnDoe211", timeAgo: "1 week ago", text: "@jjJaneCooper you were able to fully describe what I was thinking.", replies: nil)
            ]),
            Comment(username: "jennyWilson1", timeAgo: "1 week ago", text: "@NoahPierre158 Thanks! 🥰", replies: nil)
        ]),
        Comment(username: "JohnDoe211", timeAgo: "1 week ago", text: "It’s just perfect 😁😁😁", replies: nil),
        Comment(username: "jennyWilson1", timeAgo: "1 week ago", text: "Thank you all for such lovely comments!", replies: nil)
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(comments) { comment in
                    CommentRow(comment: comment)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Comments")
        }
    }
}

struct CommentRow: View {
    let comment: Comment
    @State private var showReplies: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(comment.username).bold()
                Spacer()
                Text(comment.timeAgo).font(.caption).foregroundColor(.gray)
            }
            Text(comment.text)
            
            if let replies = comment.replies, !replies.isEmpty {
                Button(action: {
                    withAnimation {
                        showReplies.toggle()
                    }
                }) {
                    Text(showReplies ? "Hide replies" : "Show \(replies.count) replies")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                
                if showReplies {
                    ForEach(replies) { reply in
                        CommentRow(comment: reply)
                            .padding(.leading, 20)
                    }
                }
            }
        }
        .padding(.vertical, 5)
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView()
    }
}
*/
