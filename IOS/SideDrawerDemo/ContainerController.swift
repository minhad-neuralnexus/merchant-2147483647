//
//  ContainerController.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 23/01/25.
//

/*
import UIKit

final class ContainerController: UIViewController {
    
    static var shared: ContainerController?
    
    let mainController = ViewController()
    let sideController = SideDrawerController()
    private var drawerState: DrawerState = .closed
    
    private enum DrawerState {
        case opened
        case closed
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ContainerController.shared = self
        
        addChild(sideController)
        view.addSubview(sideController.view)
        sideController.didMove(toParent: self)
        
        addChild(mainController)
        view.addSubview(mainController.view)
        mainController.didMove(toParent: self)
        
        setupGestures()
    }
    
    private func setupGestures() {
        // Swipe left to close drawer
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        // Swipe right to open drawer
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
//            closeDrawer()
            toggleDrawerState()
        case .right:
//            openDrawer()
            toggleDrawerState()
        default:
            break
        }
    }
    
    func toggleDrawerState() {
        switch drawerState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10.5) {
                self.mainController.view.frame.origin.x = self.mainController.view.frame.width
            } completion: { completed in
                self.drawerState = .opened
            }
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10.5) {
                self.mainController.view.frame.origin.x = 0
            } completion: { completed in
                self.drawerState = .closed
            }
        }
    }
}

*/
import UIKit

final class ContainerController: UIViewController {
    
    let mainController = ViewController()
    let sideController = SideDrawerController()
    private var drawerState: DrawerState = .closed
    
    private enum DrawerState {
        case opened
        case closed
    }
    
    // Constraints for animating the main controller
    private var mainControllerLeadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupGestures()
    }
    
    private func setupViews() {
        // Add side drawer as a child
        addChild(sideController)
        view.addSubview(sideController.view)
        sideController.didMove(toParent: self)
        sideController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Add main controller as a child
        addChild(mainController)
        view.addSubview(mainController.view)
        mainController.didMove(toParent: self)
        mainController.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        // Set up side drawer constraints
        NSLayoutConstraint.activate([
            sideController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sideController.view.topAnchor.constraint(equalTo: view.topAnchor),
            sideController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sideController.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7) // 70% of screen width
        ])
        
        // Set up main controller constraints
        mainControllerLeadingConstraint = mainController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        NSLayoutConstraint.activate([
            mainController.view.topAnchor.constraint(equalTo: view.topAnchor),
            mainController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainControllerLeadingConstraint
        ])
    }
    
    private func setupGestures() {
        // Swipe left to close drawer
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        // Swipe right to open drawer
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        // Pan gesture to drag the drawer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            closeDrawer()
        case .right:
            openDrawer()
        default:
            break
        }
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            // Update the main controller's position while dragging
            let newConstant = mainControllerLeadingConstraint.constant + translation.x
            if newConstant >= 0 && newConstant <= view.frame.width * 0.7 {
                mainControllerLeadingConstraint.constant = newConstant
                view.layoutIfNeeded()
            }
            gesture.setTranslation(.zero, in: view)
            
        case .ended:
            let velocity = gesture.velocity(in: view).x
            
            // Determine whether to open or close based on velocity and position
            if velocity > 0 { // Swipe right (open)
                if mainControllerLeadingConstraint.constant > view.frame.width * 0.35 || velocity > 500 {
                    openDrawer()
                } else {
                    closeDrawer()
                }
            } else { // Swipe left (close)
                if mainControllerLeadingConstraint.constant < view.frame.width * 0.35 || velocity < -500 {
                    closeDrawer()
                } else {
                    openDrawer()
                }
            }
            
        default:
            break
        }
    }
    
    private func openDrawer() {
        guard drawerState == .closed else { return }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1) {
            self.mainControllerLeadingConstraint.constant = self.view.frame.width * 0.7
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.drawerState = .opened
        }
    }
    
    private func closeDrawer() {
        guard drawerState == .opened else { return }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1) {
            self.mainControllerLeadingConstraint.constant = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.drawerState = .closed
        }
    }
}
