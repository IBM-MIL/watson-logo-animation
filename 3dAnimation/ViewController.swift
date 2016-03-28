//
//  ViewController.swift
//  3dAnimation
//
//  Created by Harrison Saylor on 3/22/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let emitterLayer = CAEmitterLayer()
    let emitterCell = CAEmitterCell()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.blackColor()
        let av = createAvatarFrame()
        
        for _ in 1 ... 13 {
            addPlaneToLayer(av, plane1: createOrbitLayer(makeRandomTransform(), color: makeRandomColor()))
        }
        
        setupEmitterLayer(av)
        setupEmitterCell()
        emitterLayer.emitterCells = [emitterCell]
        av.addSublayer(emitterLayer)
        
    }
    
    func createAvatarFrame() -> CALayer {
        let container = CALayer()
        let x = CGRectGetMidX(view.bounds)
        let y = CGRectGetMidY(view.bounds)
        container.frame = CGRectMake(x-80, y-80, 160, 160)
        self.view.layer.addSublayer(container)
        
        return container
    }
    
    func createOrbitLayer(transform: CATransform3D? = nil, color: CGColor? = nil) -> CAShapeLayer {
        let loopPath = UIBezierPath()
        
        let x = CGRectGetMidX(view.bounds)
        let y = CGRectGetMidY(view.bounds)
        
        //TODO: Fix boundingRect so that it's more customizable
        let boundingRect = CGRectMake(x-80, y-80, 160, 160)
        
        let ovalStartAngle = CGFloat(90.01 * M_PI/180)
        let ovalEndAngle = CGFloat(90 * M_PI/180 + 2*M_PI)
        //TODO: Fix the center point to line up with a more dynamic boundingRect
        loopPath.addArcWithCenter(CGPointMake(80, 80),
            radius: CGRectGetWidth(boundingRect) / 2,
            startAngle: ovalStartAngle,
            endAngle: ovalEndAngle, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = loopPath.CGPath
        if(transform != nil) {
            shapeLayer.transform = transform!
        }
        shapeLayer.lineWidth = 3.0
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        if(color != nil) {
            shapeLayer.strokeColor = color!
        } else {
            shapeLayer.strokeColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).CGColor
        }
        
        shapeLayer.backgroundColor = UIColor.magentaColor().CGColor
        
        createCircle(loopPath, layer: shapeLayer, color: color)
        
        
        return shapeLayer
    }
    
    func createCircle(path: UIBezierPath, layer: CALayer, radius: CGFloat? = 5, color: CGColor? = nil) {
        
        let orbiter = UIBezierPath()
        let ovalStartAngle = CGFloat(90.01 * M_PI/180)
        let ovalEndAngle = CGFloat(90 * M_PI/180 + 2*M_PI)
        orbiter.addArcWithCenter(CGPointMake(0, 0),
            radius: radius!,
            startAngle: ovalStartAngle,
            endAngle: ovalEndAngle,
            clockwise: true)
        let orbitLayer = CAShapeLayer()
        orbitLayer.path = orbiter.CGPath
        if( color != nil) {
            orbitLayer.fillColor = color
        } else {
            orbitLayer.fillColor = UIColor.whiteColor().CGColor
        }
        
        if let inverseRotationTransform = calcInverse4x4(getRotationMatrix(layer.transform)) {
            print("Applying inverse rotation")
            orbitLayer.transform = inverseRotationTransform
            print(orbitLayer.transform)
        }
        
        // TODO: Rotate orbitLayer so that it's prersepctive faces the camera (or just replace the circle with a sphere...)
        
        layer.addSublayer(orbitLayer)
        
        let path = path
        
        let anim = CAKeyframeAnimation(keyPath: "position")
        
        anim.path = path.CGPath
        
        anim.repeatCount = Float.infinity
        anim.duration = 3.0
        anim.removedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        
        orbitLayer.addAnimation(anim, forKey: "animate position along path")

    }
    
    func addPlaneToLayer(plane0: CALayer, plane1: CALayer) {
        plane0.addSublayer(plane1)
    }
    
    func makeRandomTransform() -> CATransform3D {
        let randomTilt = arc4random_uniform(UInt32(360))
        let randomAxisX = CGFloat(arc4random_uniform(UInt32(2)))
        let randomAxisY = CGFloat(arc4random_uniform(UInt32(2)))
        //let randomAxisZ = CGFloat(arc4random_uniform(UInt32(2)))
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, 80, 80, 0)
        transform = CATransform3DRotate(transform, degreesToRadians(Double(randomTilt)), randomAxisX, randomAxisY, 0.0)
        transform = CATransform3DTranslate(transform, -80, -80, 0)
        return transform
    }
    
    func makeRandomColor() -> CGColor {
        let randomR = CGFloat(arc4random_uniform(UInt32(101))) / 100.0
        let randomG = CGFloat(arc4random_uniform(UInt32(101))) / 100.0
        let randomB = CGFloat(arc4random_uniform(UInt32(101))) / 100.0
        return UIColor(red: randomR, green: randomG, blue: randomB, alpha: 1.0).CGColor
    }
    
    func degreesToRadians(degrees: Double) -> CGFloat {
        return CGFloat(degrees * M_PI / 180.0)
    }
    
    func calcDeterminate4x4(transform: CATransform3D) -> CGFloat {
        return transform.m11 * transform.m22 * transform.m33 * transform.m44 +
               transform.m11 * transform.m23 * transform.m34 * transform.m42 +
               transform.m11 * transform.m24 * transform.m32 * transform.m43 +
               transform.m12 * transform.m21 * transform.m34 * transform.m43 +
               transform.m12 * transform.m23 * transform.m31 * transform.m44 +
               transform.m12 * transform.m24 * transform.m33 * transform.m41 +
               transform.m13 * transform.m21 * transform.m32 * transform.m44 +
               transform.m13 * transform.m22 * transform.m34 * transform.m41 +
               transform.m13 * transform.m24 * transform.m31 * transform.m42 +
               transform.m14 * transform.m21 * transform.m33 * transform.m42 +
               transform.m14 * transform.m22 * transform.m31 * transform.m43 +
               transform.m14 * transform.m23 * transform.m32 * transform.m41 -
               transform.m11 * transform.m22 * transform.m34 * transform.m43 -
               transform.m11 * transform.m23 * transform.m31 * transform.m44 -
               transform.m11 * transform.m24 * transform.m32 * transform.m42 -
               transform.m12 * transform.m21 * transform.m33 * transform.m44 -
               transform.m12 * transform.m23 * transform.m34 * transform.m41 -
               transform.m12 * transform.m24 * transform.m31 * transform.m43 -
               transform.m13 * transform.m21 * transform.m34 * transform.m42 -
               transform.m13 * transform.m22 * transform.m31 * transform.m44 -
               transform.m13 * transform.m24 * transform.m32 * transform.m41 -
               transform.m14 * transform.m21 * transform.m32 * transform.m43 -
               transform.m14 * transform.m22 * transform.m33 * transform.m41 -
               transform.m14 * transform.m23 * transform.m31 * transform.m42
    }
    
    func calcInverse4x4(transform: CATransform3D) -> CATransform3D? {
        let a = transform
        let detA = calcDeterminate4x4(a)
        if detA == 0.0 {
            return nil
        }
        
        let inverse = 1/detA
        let b11 = inverse * (a.m22 * a.m33 * a.m44 + a.m23 * a.m34 * a.m42 + a.m24 * a.m32 * a.m43 - a.m22 * a.m34 * a.m43 - a.m23 * a.m32 * a.m44 - a.m24 * a.m33 * a.m42)
        let b12 = inverse * (a.m12 * a.m34 * a.m43 + a.m13 * a.m32 * a.m44 + a.m14 * a.m33 * a.m42 - a.m12 * a.m33 * a.m44 - a.m13 * a.m34 * a.m42 - a.m14 * a.m32 * a.m43)
        let b13 = inverse * (a.m12 * a.m23 * a.m44 + a.m13 * a.m24 * a.m42 + a.m14 * a.m22 * a.m43 - a.m12 * a.m24 * a.m43 - a.m13 * a.m22 * a.m44 - a.m14 * a.m23 * a.m42)
        let b14 = inverse * (a.m12 * a.m24 * a.m33 + a.m13 * a.m22 * a.m34 + a.m14 * a.m23 * a.m32 - a.m12 * a.m23 * a.m34 - a.m13 * a.m24 * a.m32 - a.m14 * a.m22 * a.m33)
        let b21 = inverse * (a.m21 * a.m34 * a.m43 + a.m23 * a.m31 * a.m44 + a.m24 * a.m33 * a.m41 - a.m21 * a.m33 * a.m44 - a.m23 * a.m34 * a.m41 - a.m24 * a.m31 * a.m43)
        let b22 = inverse * (a.m11 * a.m33 * a.m44 + a.m13 * a.m34 * a.m41 + a.m14 * a.m31 * a.m43 - a.m11 * a.m34 * a.m43 - a.m13 * a.m31 * a.m44 - a.m14 * a.m33 * a.m41)
        let b23 = inverse * (a.m11 * a.m24 * a.m43 + a.m13 * a.m21 * a.m44 + a.m14 * a.m23 * a.m41 - a.m11 * a.m23 * a.m44 - a.m13 * a.m24 * a.m41 - a.m14 * a.m21 * a.m43)
        let b24 = inverse * (a.m11 * a.m23 * a.m34 + a.m13 * a.m24 * a.m31 + a.m14 * a.m21 * a.m33 - a.m11 * a.m24 * a.m33 - a.m13 * a.m21 * a.m34 - a.m14 * a.m23 * a.m31)
        let b31 = inverse * (a.m21 * a.m32 * a.m44 + a.m22 * a.m34 * a.m41 + a.m24 * a.m31 * a.m42 - a.m21 * a.m34 * a.m42 - a.m22 * a.m31 * a.m44 - a.m24 * a.m32 * a.m41)
        let b32 = inverse * (a.m11 * a.m34 * a.m42 + a.m12 * a.m31 * a.m44 + a.m14 * a.m32 * a.m41 - a.m11 * a.m32 * a.m44 - a.m12 * a.m34 * a.m41 - a.m14 * a.m31 * a.m42)
        let b33 = inverse * (a.m11 * a.m22 * a.m44 + a.m12 * a.m24 * a.m41 + a.m14 * a.m21 * a.m42 - a.m11 * a.m24 * a.m42 - a.m12 * a.m21 * a.m44 - a.m14 * a.m22 * a.m41)
        let b34 = inverse * (a.m11 * a.m24 * a.m32 + a.m12 * a.m21 * a.m34 + a.m14 * a.m22 * a.m31 - a.m11 * a.m22 * a.m34 - a.m12 * a.m24 * a.m31 - a.m14 * a.m21 * a.m32)
        let b41 = inverse * (a.m21 * a.m33 * a.m42 + a.m22 * a.m31 * a.m43 + a.m23 * a.m32 * a.m41 - a.m21 * a.m32 * a.m43 - a.m22 * a.m33 * a.m41 - a.m23 * a.m31 * a.m42)
        let b42 = inverse * (a.m11 * a.m32 * a.m43 + a.m12 * a.m33 * a.m41 + a.m13 * a.m31 * a.m42 - a.m11 * a.m33 * a.m42 - a.m12 * a.m31 * a.m43 - a.m13 * a.m32 * a.m41)
        let b43 = inverse * (a.m11 * a.m23 * a.m42 + a.m12 * a.m21 * a.m43 + a.m13 * a.m22 * a.m41 - a.m11 * a.m22 * a.m43 - a.m12 * a.m23 * a.m41 - a.m13 * a.m21 * a.m42)
        let b44 = inverse * (a.m11 * a.m22 * a.m33 + a.m12 * a.m23 * a.m31 + a.m13 * a.m21 * a.m32 - a.m11 * a.m23 * a.m32 - a.m12 * a.m21 * a.m33 - a.m13 * a.m22 * a.m31)
        
        return CATransform3D(m11: b11, m12: b12, m13: b13, m14: b14, m21: b21, m22: b22, m23: b23, m24: b24, m31: b31, m32: b32, m33: b33, m34: b34, m41: b41, m42: b42, m43: b43, m44: b44)
        
    }
    
    func getTranslation(transform: CATransform3D) -> [CGFloat] {
        let translationMatrix = [transform.m14, transform.m24, transform.m34, transform.m44]
        return translationMatrix
    }
    
    func getScalingMatrix(transform: CATransform3D) -> [CGFloat] {
        let sX = calcScalar(transform.m11, transform.m21, transform.m31)
        let sY = calcScalar(transform.m12, transform.m22, transform.m32)
        let sZ = calcScalar(transform.m13, transform.m23, transform.m33)
        
        return [sX, sY, sZ]
    }
    
    func getRotationMatrix(transform: CATransform3D) -> CATransform3D {
        let scalingMatrix = getScalingMatrix(transform)
        
        let rX1 = transform.m11 / scalingMatrix[0]
        let rX2 = transform.m21 / scalingMatrix[0]
        let rX3 = transform.m31 / scalingMatrix[0]
        
        let rY1 = transform.m12 / scalingMatrix[1]
        let rY2 = transform.m22 / scalingMatrix[1]
        let rY3 = transform.m32 / scalingMatrix[1]
        
        let rZ1 = transform.m13 / scalingMatrix[2]
        let rZ2 = transform.m23 / scalingMatrix[2]
        let rZ3 = transform.m33 / scalingMatrix[2]
        
        return CATransform3D(m11: rX1, m12: rY1, m13: rZ1, m14: 0, m21: rX2, m22: rY2, m23: rZ2, m24: 0, m31: rX3, m32: rY3, m33: rZ3, m34: 0, m41:0, m42:0, m43: 0, m44: 0)
    }
    
    func calcScalar(vals: CGFloat...) -> CGFloat {
        var scalar = CGFloat(0.0)
        
        for val in vals {
            scalar += val * val
        }
        
        return sqrt(scalar)
    }
    
    func setupEmitterLayer(layer: CALayer) {
        emitterLayer.frame = view.bounds
        emitterLayer.seed = UInt32(NSDate().timeIntervalSince1970)
        emitterLayer.renderMode = kCAEmitterLayerAdditive
        emitterLayer.drawsAsynchronously = true
        setEmitterPosition(layer)
    }
    
    func setupEmitterCell() {
        
        emitterCell.contents = UIImage(named: "smoke")?.CGImage
        
        emitterCell.velocity = 20.0
        emitterCell.velocityRange = 100.0
        
        emitterCell.color = UIColor(red: 11/255, green: 152/255, blue: 232/255, alpha: 0.135802).CGColor
        emitterCell.redRange = 0.0
        emitterCell.greenRange = 0.0
        emitterCell.blueRange = 0.2
        emitterCell.alphaRange = 0.0
        emitterCell.redSpeed = 0.0
        emitterCell.greenSpeed = 0.0
        emitterCell.blueSpeed = 0.0
        emitterCell.alphaSpeed = -0.5
        
        emitterCell.lifetime = 10.0
        emitterCell.birthRate = 50.0
        emitterCell.xAcceleration = -150
        emitterCell.yAcceleration = 150
        emitterCell.zAcceleration = 150
    }
    
    func setEmitterPosition(layer: CALayer) {
        emitterLayer.emitterPosition = CGPoint(x: CGRectGetMidX(layer.bounds), y: CGRectGetMidY(layer.bounds))
        emitterLayer.emitterZPosition = 100.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

