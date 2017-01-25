//
//  IBMWLA_SCNNodeAgent_Orbits.swift
//  3dAnimation
//
//  Created by Juguang Xiao on 26/01/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import SceneKit

class IBMWLA_SCNNodeAgent_Orbits: NSObject {

    private let program = SCNProgram()
    
    override init() {
        super.init()
        
        guard let pathFrag = Bundle.main.path(forResource: "cometShader", ofType: "fsh") else {
            print("Error finding cometShader fragment shader")
            return
        }
        
        guard let pathVert = Bundle.main.path(forResource: "cometShader", ofType: "vsh") else {
            print("Error finding cometShader vertex shader")
            return
        }
        
        do {
            let fragmentSource = try String(contentsOfFile: pathFrag, encoding: String.Encoding.utf8)
            let vertexSource = try String(contentsOfFile: pathVert, encoding: String.Encoding.utf8)
            program.fragmentShader = fragmentSource as String
            program.vertexShader = vertexSource as String
            program.setSemantic(SCNModelViewProjectionTransform, forSymbol: "u_MVPMatrix", options: nil)
            //program.setSemantic(SCNGeometrySourceSemanticVertex, forSymbol: "vertPos", options: nil)
            //program.setSemantic(SCNGeometrySourceSemanticTexcoord, forSymbol: "texCoord", options: nil)
        } catch {
            print("Error loading shaders")
        }
    }
    
    func orbits() -> [SCNNode] {
        
        var o_ = [SCNNode]()
        let first =  createOrbit(10, color: IBMWLA_Random.randomColoredMaterial())
        o_.append(first)
        
        for _ in 1 ... 9 {
            let myRotation = IBMWLA_Random.randomRotation()
            o_.append(createOrbit(10, color:  IBMWLA_Random.randomColoredMaterial(), transform: myRotation))
        }
        
        
        return o_
        
    }
    
    private func createOrbit(_ radius: CGFloat, color: SCNMaterial, girth: CGFloat? = 0.5, transform: SCNMatrix4? = nil) -> SCNNode {
        
        let ring = SCNTorus(ringRadius: radius, pipeRadius: girth!)
        ring.materials = [color]
        let ringNode = SCNNode(geometry: ring)
        
        
        
        //TODO: Create the tail effect
        // It seems to me that the best way to go about this is to use a shader that modifies transparency
        
        //ring.program = program
        
        let nullNode = SCNNode()
        nullNode.position = SCNVector3(0,0,0)
        //TODO: Allow modification of this rotation (probably just positive, negative, and duration)
        let action = SCNAction.rotate(by: 90, around: SCNVector3(0, 1, 0), duration: 30)
        nullNode.runAction(SCNAction.repeatForever(action))
        ringNode.addChildNode(nullNode)
        
        let sphereGeometry = SCNSphere(radius: girth! * 2)
        sphereGeometry.materials = [color]
        let sphereNode = SCNNode(geometry: sphereGeometry)
        //TODO: Randomly generate a position on the torus
        //Wel, maybe this isn't necessary. Can achieve a similar effect just by rotating the base node a bit
        sphereNode.transform = SCNMatrix4MakeTranslation(Float(radius), 0, 0)
        nullNode.addChildNode(sphereNode)
        
        if let t = transform {
            ringNode.transform = t
        }
        
        return ringNode
    }
}
