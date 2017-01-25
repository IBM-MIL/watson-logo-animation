//
//  IBMWLA_Random.swift
//  3dAnimation
//
//  Created by Juguang Xiao on 26/01/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import SceneKit



class IBMWLA_Random {
    
    static func randomRotation() -> SCNMatrix4 {
        let randomTilt = Float(arc4random_uniform(UInt32(360)))
        let randomAxisX = Float(arc4random_uniform(UInt32(2)))
        let randomAxisY = Float(arc4random_uniform(UInt32(2)))
        let randomAxisZ = Float(arc4random_uniform(UInt32(2)))
        let rotation = SCNMatrix4MakeRotation(randomTilt, randomAxisX, randomAxisY, randomAxisZ)
        return rotation
    }
    
    static func randomColoredMaterial() -> SCNMaterial {
        let myMat = SCNMaterial()
        myMat.diffuse.contents = makeRandomColor()
        return myMat
    }
    
    static  func makeRandomColor() -> UIColor {
        let randomR = CGFloat(arc4random_uniform(UInt32(101))) / 100.0
        let randomG = CGFloat(arc4random_uniform(UInt32(101))) / 100.0
        let randomB = CGFloat(arc4random_uniform(UInt32(101))) / 100.0
        return UIColor(red: randomR, green: randomG, blue: randomB, alpha: 1.0)
    }
    
}
