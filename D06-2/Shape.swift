//
//  Shape.swift
//  D06-2
//
//  Created by Volodymyr KOZHEMIAKIN on 1/23/19.
//  Copyright © 2019 Volodymyr KOZHEMIAKIN. All rights reserved.
//

import Foundation
import UIKit

class Shape : UIView {
    
    
    var size : CGFloat = 100
    var random : Int = 0
    
    init(point: CGPoint, maxWidth: CGFloat, maxHeight: CGFloat ) {
        var x = point.x - size/2
        var y = point.y - size/2
        // to avoid shapes coming out of the box
        if x + size/2 > maxWidth {
            x = x - size/2
        }
        if y + size/2 > maxHeight {
            y = y - size/2
        }
        // randomly generate a square or a circle
        random = Int(arc4random_uniform(2)) // set to 2 to also have circles
        if random == 0 {
            super.init(frame: CGRect(x: x, y: y, width: size, height: size))
        } else {
            super.init(frame: CGRect(x: x, y: y, width: size, height: size))
            self.layer.cornerRadius = size/2
        }
        // random color
        self.backgroundColor = getRandomColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getRandomColor() -> UIColor {
        // drand48() Generate between 0.0 to 1.0
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    
    
    
    // to make rect in cirkle
    
//    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
//        if isCircle {
//            return .ellipse
//        } else {
//            return .rectangle
//        }
//    }
    
    
    
//    var lineWidth: CGFloat = 3
//
//    var shapeLayer: CAShapeLayer = {
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.strokeColor = UIColor.blue.cgColor
//        shapeLayer.fillColor = UIColor.blue.withAlphaComponent(0.5).cgColor
//        return shapeLayer
//    }()
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        layer.addSublayer(shapeLayer)
//        shapeLayer.lineWidth = lineWidth
//        let center = CGPoint(x: bounds.midX, y: bounds.midY)
//        shapeLayer.path = circularPath(lineWidth: lineWidth, center: center).cgPath
//    }
//
//    private func circularPath(lineWidth: CGFloat = 0, center: CGPoint = .zero) -> UIBezierPath {
//        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
//        return UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
//    }
//
//    override var collisionBoundsType: UIDynamicItemCollisionBoundsType { return .path }
//
//    override var collisionBoundingPath: UIBezierPath { return circularPath() }
//
    
}
