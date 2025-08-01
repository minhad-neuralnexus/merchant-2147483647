//
//  HomeController.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 23/01/25.
//

import SwiftUI
import UIKit
import SocketIO

final class HomeController: UIViewController {
    
    private static var manager = SocketManager(socketURL: URL(string: "wss://jupyter.evers.works/")!, config: [.log(true)])
    private let socket = manager.defaultSocket
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Home"
        
        let button = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(toggleSidebar))
        navigationItem.leftBarButtonItem = button
        
        //        presentSwiftUIView()
        // Set up event handlers
//        setupSocketEvents()
        
        let webSocketTask = URLSession.shared.webSocketTask(with: URL(string: "wss://jupyter.evers.works/call")!)
        webSocketTask.resume()
        
        webSocketTask.send(.string("Hello")) { err in
            if let error = err {
                print("Error sending a message: \(error)")
            } else {
                print("done send ")
            }
            
        }
        
        webSocketTask.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Received data: \(data)")
                case .string(let text):
                    print("Received text: \(text)")
                }
            case .failure(let error):
                print("Error receiving message: \(error)")
            }
        }
        
        // Connect to the server
//        socket.connect()
        
    }
    
    func setupSocketEvents() {
        // Handle connection event
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket connected! getting data from API")
            
            URLSession.shared.dataTask(with: URL(string: "http://localhost:3002/")!) { data, _, error in
                let dataAsString = String(data: data!, encoding: .utf8)
                print(dataAsString!)
            }.resume()
        }
        
        // Handle custom "chat message" event
        socket.on("chat message") { data, ack in
            if let message = data[0] as? String {
                print("Received message: \(message)")
            }
        }
        
        // Handle disconnection event
        socket.on(clientEvent: .disconnect) { data, ack in
            print("Socket disconnected!")
        }
    }
    
    // Function to send a message to the server
    func sendMessage(_ message: String) {
//        socket.emit("chat message", message)
        socket.emit("follow", ["user_id": 4, "self_id": 1])
    }
    
    // Example: Send a message when a button is tapped
    func sendButtonTapped() {
        sendMessage("Hello from iOS!")
    }
    
    
    func presentSwiftUIView() {
        let swiftUIView = PracticeView()
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true, completion: nil)
    }
    
    @objc private func toggleSidebar() {
//        ContainerController.shared?.toggleDrawerState()
        sendButtonTapped()
    }
}
