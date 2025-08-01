//
//  PathController.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 18/02/25.
//

import UIKit

final class PathController: UIViewController {
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
        view.backgroundColor = .systemBackground
//        createPath()
        // Create the Bezier path for the letter "U"
        let uPath = UIBezierPath()
        uPath.move(to: CGPoint(x: 50, y: 100)) // Start at the top-left of the "U"
//        uPath.addLine(to: CGPoint(x: 50, y: 200)) // Draw the left vertical line
//        uPath.addQuadCurve(to: CGPoint(x: 150, y: 200), controlPoint: CGPoint(x: 100, y: 250)) // Draw the bottom curve
//        uPath.addLine(to: CGPoint(x: 150, y: 100)) // Draw the right vertical line
//        
//        uPath.move(to: CGPoint(x: 250, y: 100))
//        uPath.addLine(to: .init(x: 250, y: 200))
        uPath.addLine(to: .init(x: 50, y: 200))
        uPath.move(to: .init(x: 50, y: 150))
        uPath.addLine(to: .init(x: 100, y: 150))
        uPath.move(to: .init(x: 100, y: 100))
        uPath.addLine(to: .init(x: 100, y: 200))
        
//        A
        uPath.move(to: .init(x: 120, y: 100))
        uPath.addLine(to: .init(x: 110, y: 200))
        uPath.move(to: .init(x: 120, y: 100))
        uPath.addLine(to: .init(x: 140, y: 200))
        
        // Create a CAShapeLayer to represent the path
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = uPath.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 5.0
        shapeLayer.strokeEnd = 0.0 // Start with the path not drawn
        
        // Add the shape layer to the view's layer
        view.layer.addSublayer(shapeLayer)
        
        // Animate the drawing of the path
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 2.0 // Duration of the animation
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        // Add the animation to the shape layer
        shapeLayer.add(animation, forKey: "drawUAnimation")
        
        // Update the strokeEnd to 1.0 to keep the path drawn after the animation
        shapeLayer.strokeEnd = 1.0
    }
    
    
    private func createPath() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 100, y: 100))
        path.addLine(to: CGPoint(x: 200, y: 100))
        path.addLine(to: CGPoint(x: 150, y: 200))
        
        // Create a shapelayer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 5.0
        shapeLayer.strokeEnd = 0.0 // Start with the path not drawn
        // Add the shape layer to the view's layer
        view.layer.addSublayer(shapeLayer)
        
    }
}
