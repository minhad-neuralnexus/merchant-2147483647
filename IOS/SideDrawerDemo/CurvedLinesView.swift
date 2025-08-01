//
//  CurvedLinesView.swift
//  SideDrawerDemo
//
//  Created by Hamza Usmani on 18/02/25.
//


import UIKit

class CurvedLinesView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Define the curves using UIBezierPath
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 50, y: 100))
        path1.addQuadCurve(to: CGPoint(x: 300, y: 100), controlPoint: CGPoint(x: 175, y: 50))
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 50, y: 200))
        path2.addQuadCurve(to: CGPoint(x: 300, y: 200), controlPoint: CGPoint(x: 175, y: 250))
        
        let path3 = UIBezierPath()
        path3.move(to: CGPoint(x: 50, y: 300))
        path3.addQuadCurve(to: CGPoint(x: 300, y: 300), controlPoint: CGPoint(x: 175, y: 350))
        
        // Create a shape layer for each path
        let shapeLayer1 = createGradientShapeLayer(for: path1, colors: [UIColor.orange.cgColor, UIColor.blue.cgColor])
        let shapeLayer2 = createGradientShapeLayer(for: path2, colors: [UIColor.orange.cgColor, UIColor.blue.cgColor])
        let shapeLayer3 = createGradientShapeLayer(for: path3, colors: [UIColor.orange.cgColor, UIColor.blue.cgColor])
        
        // Add the shape layers to the view's layer
        self.layer.addSublayer(shapeLayer1)
        self.layer.addSublayer(shapeLayer2)
        self.layer.addSublayer(shapeLayer3)
    }
    
    private func createGradientShapeLayer(for path: UIBezierPath, colors: [CGColor]) -> CAShapeLayer {
        // Create a shape layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor // Stroke color (optional)
        shapeLayer.fillColor = UIColor.clear.cgColor // No fill
        shapeLayer.lineWidth = 5
        
        // Create a gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        // Mask the gradient layer with the shape layer
        gradientLayer.mask = shapeLayer
        
        // Add the gradient layer to the view's layer
        self.layer.addSublayer(gradientLayer)
        
        // Return the shape layer (optional, depending on your use case)
        return shapeLayer
    }
}
