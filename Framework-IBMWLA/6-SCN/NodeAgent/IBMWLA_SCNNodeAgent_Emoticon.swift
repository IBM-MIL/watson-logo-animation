//
//  IBMWLA_SCNNodeAgent_Emoticon.swift
//  3dAnimation
//
//  Created by Juguang Xiao on 25/01/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import SceneKit

class IBMWLA_SCNNodeAgent_Emoticon: NSObject {

    
    private var _node : SCNNode?
    
    // was  func createEmoticon(_ color: SCNMaterial, height: CGFloat? = 6.0) -> SCNNode
    func createRootNode(_ color: SCNMaterial, height: CGFloat = 6.0) -> SCNNode? {
        
        //height may need to be something relative to radius. I don't wanna say 1/3 but it kinda looks like it might be...
        //chamferRadius can at most be half the width. If doing it with a box doens't work, will probably have to create a custom geometery from a UIBezierCurve
        let line1 = SCNBox(width: 2.0, height: height, length: 2.0, chamferRadius: 5.0)
        line1.materials = [color]
        let lineNode1 = SCNNode(geometry: line1)
        //All these positions should be some function of radius and height
        lineNode1.position = SCNVector3(0.0, 13.5 + 0.5 * height, 0.0)
        
        
        let line2 = SCNBox(width: 2.0, height: height, length: 2.0, chamferRadius: 5.0)
        line2.materials = [color]
        let lineNode2 = SCNNode(geometry: line2)
        lineNode2.transform = SCNMatrix4MakeRotation(22.5, 0.0, 0.0, 1.0)
        lineNode2.position = SCNVector3(-8.0, 11.5 + 0.5 * height, 0.0)
        
        let line3 = SCNBox(width: 2.0, height: height, length: 2.0, chamferRadius: 5.0)
        line3.materials = [color]
        let lineNode3 = SCNNode(geometry: line3)
        lineNode3.transform = SCNMatrix4MakeRotation(-22.5, 0.0, 0.0, 1.0)
        lineNode3.position = SCNVector3(8.0, 11.5 + 0.5 * height, 0.0)
        
        let line4 = SCNBox(width: 2.0, height: height, length: 2.0, chamferRadius: 5.0)
        line4.materials = [color]
        let lineNode4 = SCNNode(geometry: line4)
        lineNode4.transform = SCNMatrix4MakeRotation(45.0, 0.0, 0.0, 1.0)
        lineNode4.position = SCNVector3(-14.0, 6.0 + 0.5 * height, 0.0)
        
        let line5 = SCNBox(width: 2.0, height: height, length: 2.0, chamferRadius: 5.0)
        line5.materials = [color]
        let lineNode5 = SCNNode(geometry: line5)
        lineNode5.transform = SCNMatrix4MakeRotation(-45.0, 0.0, 0.0, 1.0)
        lineNode5.position = SCNVector3(14.0, 6.0 + 0.5 * height, 0.0)
        
        let emoticonNode = SCNNode()
        emoticonNode.addChildNode(lineNode1)
        emoticonNode.addChildNode(lineNode2)
        emoticonNode.addChildNode(lineNode3)
        emoticonNode.addChildNode(lineNode4)
        emoticonNode.addChildNode(lineNode5)
        
        _node = emoticonNode
        
        toBeInflated_ = [
            lineNode4, lineNode2, lineNode1, lineNode3, lineNode5
        ]
        
        
        return emoticonNode
    }
    
    let upBy2 = SCNAction.move(by: SCNVector3(0.0, 2.0, 0.0), duration: 0.1)
    let upBy7point5 = SCNAction.move(by: SCNVector3(0.0, 7.5, 0.0), duration: 0.1)
    let rotateTo0 = SCNAction.rotate(toAxisAngle: SCNVector4(0.0, 0.0, 0.0, 0.0), duration: 0.1)
    
    
    let inflateSequence : SCNAction = {
        let inflate = SCNAction.scale(by: 2.0, duration: 0.2)
        let deflate = SCNAction.scale(by: 0.5, duration: 0.2)
        let inflateSequence = SCNAction.sequence([inflate, deflate])
        return inflateSequence
    }()
    
    func think() {
        //this is only last for now, may have to change it later
        let emoticonNode =   _node! //  geometryNode.childNodes.last
        let lineNode1 = emoticonNode.childNodes[0]
        let lineNode2 = emoticonNode.childNodes[1]
        let lineNode3 = emoticonNode.childNodes[2]
        let lineNode4 = emoticonNode.childNodes[3]
        let lineNode5 = emoticonNode.childNodes[4]
        

        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.2
        for node in (emoticonNode.childNodes) {
            let prism = node.geometry as! SCNBox
            prism.height = 2
        }
        SCNTransaction.commit()
        
        lineNode2.runAction(upBy2)
        lineNode2.runAction(rotateTo0)
        lineNode3.runAction(upBy2)
        lineNode3.runAction(rotateTo0)
        
        lineNode4.runAction(upBy7point5)
        lineNode4.runAction(rotateTo0)
        lineNode5.runAction(upBy7point5)
        lineNode5.runAction(rotateTo0)
        
        //TODO: Fix this pyramid of doom
        //TODO: Break this out
        //TODO: Allow this sequence to be broken. It can't be right now
//        lineNode4.runAction(inflateSequence) {
//            lineNode2.runAction(inflateSequence) {
//                lineNode1.runAction(inflateSequence) {
//                    lineNode3.runAction(inflateSequence) {
//                        lineNode5.runAction(inflateSequence)
//                    }
//                }
//            }
//        }
        
        // toBeInflated_ is set up when notes are first created.
        

        inflate(index: 0)
        
    }
    
    private var toBeInflated_ = [SCNActionable]()
    
    private func inflate(index: Int) {
        let a = toBeInflated_[index]
        a.runAction(inflateSequence) { 
            if index+1 < self.toBeInflated_.count {
            self.inflate(index: index+1)
            }
        }
    }
    
    
    func alert() {
        //this is only last for now, may have to change it later
        //there's gotta be a better way to do this...
        let emoticonNode =  _node! //  geometryNode.childNodes.last
        let lineNode1 = emoticonNode.childNodes[0]
        let lineNode2 = emoticonNode.childNodes[1]
        let lineNode3 = emoticonNode.childNodes[2]
        let lineNode4 = emoticonNode.childNodes[3]
        let lineNode5 = emoticonNode.childNodes[4]
        
        lineNode1.runAction(SCNAction.scale(to: 1.5, duration: 0.1))
        
        lineNode2.runAction(SCNAction.rotateTo(x: 0.0, y: 0.0, z: 0.0, duration: 0.1))
        lineNode2.runAction(SCNAction.move(to: SCNVector3(0.0, 25.0, 0.0), duration: 0.1))
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.2
        let line1 = lineNode1.geometry as! SCNBox
        let line2 = lineNode2.geometry as! SCNBox
        let line3 = lineNode3.geometry as! SCNBox
        let line4 = lineNode4.geometry as! SCNBox
        let line5 = lineNode5.geometry as! SCNBox
        line1.height = 2.0
        line2.height = 10.0
        line3.height = 4.0
        line4.height = 4.0
        line5.height = 6.0
        SCNTransaction.commit()
        
        lineNode3.runAction(SCNAction.move(to: SCNVector3(9.0, 13.0, 0.0), duration: 0.1))
        lineNode3.runAction(SCNAction.rotateTo(x: 0.0, y: 0.0, z: degreesToRadians(160), duration: 0.1))
        
        lineNode4.runAction(SCNAction.move(to: SCNVector3(14.0, 6.0, 0.0), duration: 0.1))
        lineNode4.runAction(SCNAction.rotateTo(x: 0.0, y: 0.0, z: degreesToRadians(100), duration: 0.1))
        
        lineNode5.runAction(SCNAction.move(to: SCNVector3(13.0, 11.0, 0.0), duration: 0.1))
        lineNode5.runAction(SCNAction.rotateTo(x: 0.0, y: 0.0, z: degreesToRadians(130), duration: 0.1))
    }
    
    func reset() {
        //this is only last for now, may have to change it later
        //there's gotta be a better way to do this...
        let emoticonNode = _node! // geometryNode.childNodes.last
        let lineNode1 = emoticonNode.childNodes[0]
        let lineNode2 = emoticonNode.childNodes[1]
        let lineNode3 = emoticonNode.childNodes[2]
        let lineNode4 = emoticonNode.childNodes[3]
        let lineNode5 = emoticonNode.childNodes[4]
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.2
        for node in (emoticonNode.childNodes) {
            let prism = node.geometry as! SCNBox
            prism.height = 6.0
        }
        
        //3.0 is height / 2, but I really gotta decide how I'm gonna do scaling. Magic numbers are bad
        lineNode1.scale = SCNVector3(1.0, 1.0, 1.0)
        lineNode1.position = SCNVector3(0.0, 13.5 + 3.0, 0.0)
        
        lineNode2.transform = SCNMatrix4MakeRotation(22.5, 0.0, 0.0, 1.0)
        lineNode2.position = SCNVector3(-8.0, 11.5 + 3.0, 0.0)
        
        lineNode3.transform = SCNMatrix4MakeRotation(-22.5, 0.0, 0.0, 1.0)
        lineNode3.position = SCNVector3(8.0, 11.5 + 3.0, 0.0)
        
        lineNode4.transform = SCNMatrix4MakeRotation(45.0, 0.0, 0.0, 1.0)
        lineNode4.position = SCNVector3(-14.0, 6.0 + 3.0, 0.0)
        
        lineNode5.transform = SCNMatrix4MakeRotation(-45.0, 0.0, 0.0, 1.0)
        lineNode5.position = SCNVector3(14.0, 6.0 + 3.0, 0.0)
        
        SCNTransaction.commit()
        
    }
    
    
    func degreesToRadians(_ degrees: Double) -> CGFloat {
        return CGFloat(degrees * M_PI / 180.0)
    }
}

