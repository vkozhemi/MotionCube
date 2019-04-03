//
//  ViewController.swift
//  D06-2
//
//  Created by Volodymyr KOZHEMIAKIN on 1/23/19.
//  Copyright © 2019 Volodymyr KOZHEMIAKIN. All rights reserved.
//

import UIKit
import CoreMotion

var i = -1

class ViewController: UIViewController {
    
    var dynamycAnimator: UIDynamicAnimator!
    var gravityBehavior: UIGravityBehavior!
    var collisionBehavior: UICollisionBehavior!
    var itemBehaviour: UIDynamicItemBehavior!
    let motionManager = CMMotionManager()
   
    
    @IBAction func tapAction(_ sender: AnyObject) {
        let shape = Shape(point: sender.location(in: view), maxWidth: self.view.bounds.width, maxHeight: self.view.bounds.height)
        i += 1
        print("\(i). Tap on position \(sender.location(in: view))")
        
        gravityBehavior.magnitude = 1 // The magnitude of the gravity vector.
        view.addSubview(shape)
        gravityBehavior.addItem(shape)
        collisionBehavior.addItem(shape)
        itemBehaviour.addItem(shape)
        
        // UIPanGestureRecognizer
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(gesture:)))
        shape.addGestureRecognizer(gesture)
        
        // UIPinchGestureRecognizer
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(recognizer:)))
        shape.addGestureRecognizer(pinch)
        
        // UIRotationGesture
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(recognizer:)))
        shape.addGestureRecognizer(rotate)
        
    }
    
    
    @objc func panGesture (gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            print("Began")
            self.gravityBehavior.removeItem(gesture.view!) // Removes the specified dynamic item from the gravity behavior.
        case .changed:
            print("Changed to \(gesture.location(in: view))")
            gesture.view?.center = gesture.location(in: gesture.view?.superview)
            dynamycAnimator.updateItem(usingCurrentState: gesture.view!) // replacing the animator’s internal representation of the item’s state
        case .ended:
            print("Ended")
            self.gravityBehavior.addItem(gesture.view!) // Associates the specified dynamic item with the gravity behavior.
        case .failed, .cancelled:
            print("Failed or Cancelled")
        case .possible:
            print("Possible")
        }
    }
    
    @objc func handlePinch(recognizer : UIPinchGestureRecognizer) {
        print("handlePinch")
        if let view = recognizer.view {
            print(recognizer.scale)
            switch recognizer.state {
            case .began:
                print("Began")
                self.gravityBehavior.removeItem(view)
                self.collisionBehavior.removeItem(view)
                self.itemBehaviour.removeItem(view)
            case.changed:
                print("Changed")
                recognizer.view?.layer.bounds.size.height *= recognizer.scale
                recognizer.view?.layer.bounds.size.width *= recognizer.scale
                if let tmp = recognizer.view! as? Shape {
                    if (tmp.random == 1) {recognizer.view!.layer.cornerRadius *= recognizer.scale}}
                recognizer.scale = 1
            case .ended:
                print("Ended")
                self.gravityBehavior.addItem(view)
                self.collisionBehavior.addItem(view)
                self.itemBehaviour.addItem(view)
            case .failed, .cancelled:
                print("Failed or Cancelled")
            case .possible:
                print("Possible")
            }
        }
    }
    
    @objc func handleRotate(recognizer : UIRotationGestureRecognizer) {
        print("handleRotate")
        if let view = recognizer.view {
            print(recognizer.rotation)
            switch recognizer.state {
            case .began:
                print("Began")
                self.gravityBehavior.removeItem(view)
            case.changed:
                print("Changed")
                view.transform = view.transform.rotated(by: recognizer.rotation)
                dynamycAnimator.updateItem(usingCurrentState: recognizer.view!)
                recognizer.rotation = 0
            case .ended:
                print("Ended")
                self.gravityBehavior.addItem(view)
            case .failed, .cancelled:
                print("Failed or Cancelled")
            case .possible:
                print("Possible")
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dynamycAnimator = UIDynamicAnimator(referenceView: view)
        gravityBehavior = UIGravityBehavior()
        dynamycAnimator.addBehavior(gravityBehavior)
        
        collisionBehavior = UICollisionBehavior()
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        dynamycAnimator.addBehavior(collisionBehavior)
        
        itemBehaviour = UIDynamicItemBehavior()
        itemBehaviour.elasticity = 0.5
        dynamycAnimator.addBehavior(itemBehaviour)

    }

    // this function uses the accelerometer data to change the direction of gravity vector
    func accelerometerDirection(data: CMAccelerometerData?, error: Error?) {
        print("accelerometerDirection")
        if let myData = data {
            let x = CGFloat(myData.acceleration.x);
            let y = CGFloat(myData.acceleration.y);
            print("x = \(x), y = \(y)")
            let vector = CGVector(dx: x, dy: -y);
            gravityBehavior.gravityDirection = vector; //The direction and magnitude of the gravitational force, expressed as a vector.
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1 // frequency
            let queue = OperationQueue.main
            motionManager.startAccelerometerUpdates(to: queue, withHandler: accelerometerDirection )
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if motionManager.isAccelerometerAvailable {
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

