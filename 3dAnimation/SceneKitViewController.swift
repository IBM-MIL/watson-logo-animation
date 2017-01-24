//
//  SceneKitViewController.swift
//  3dAnimation
//
//  Created by Harrison Saylor on 3/28/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation
import AVFoundation
import SceneKit

class SceneKitViewController : UIViewController {
    
    @IBOutlet weak var sceneView: SCNView!
    
    var program = SCNProgram()
    
    //Particle System
    let particleSystem = SCNParticleSystem(named: "SceneKitSmoke", inDirectory: nil)!
    
    //Geometry
    var geometryNode: SCNNode = SCNNode()
    
    // Gestures
    var currentAngle: Float = 0.0
    
    //Audio
    var player = AVAudioPlayer()
    
    //Colors
    static let watsonBlue = UIColor(red: 11/255, green: 152/255, blue: 232/255, alpha: 1.0)
    
    @IBAction func onSpeakPressed(_ sender: AnyObject) {
        player.play()
    }
    
    @IBAction func onSurprisePressed(_ sender: AnyObject) {
        alert()
    }
    
    @IBAction func onResetPressed(_ sender: AnyObject) {
        reset()
    }

    @IBAction func onAnimatePressed(_ sender: AnyObject) {
        //this is only last for now, may have to change it later
        let emoticonNode = geometryNode.childNodes.last
        let lineNode1 = emoticonNode?.childNodes[0]
        let lineNode2 = emoticonNode?.childNodes[1]
        let lineNode3 = emoticonNode?.childNodes[2]
        let lineNode4 = emoticonNode?.childNodes[3]
        let lineNode5 = emoticonNode?.childNodes[4]
        
        let upBy2 = SCNAction.move(by: SCNVector3(0.0, 2.0, 0.0), duration: 0.1)
        let upBy7point5 = SCNAction.move(by: SCNVector3(0.0, 7.5, 0.0), duration: 0.1)
        let rotateTo0 = SCNAction.rotate(toAxisAngle: SCNVector4(0.0, 0.0, 0.0, 0.0), duration: 0.1)
        let inflate = SCNAction.scale(by: 2.0, duration: 0.2)
        let deflate = SCNAction.scale(by: 0.5, duration: 0.2)
        let inflateSequence = SCNAction.sequence([inflate, deflate])
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.2
        for node in (emoticonNode?.childNodes)! {
            let prism = node.geometry as! SCNBox
            prism.height = 2
        }
        SCNTransaction.commit()
        
        lineNode2?.runAction(upBy2)
        lineNode2?.runAction(rotateTo0)
        lineNode3?.runAction(upBy2)
        lineNode3?.runAction(rotateTo0)
        
        lineNode4?.runAction(upBy7point5)
        lineNode4?.runAction(rotateTo0)
        lineNode5?.runAction(upBy7point5)
        lineNode5?.runAction(rotateTo0)
        
        //TODO: Fix this pyramid of doom
        //TODO: Break this out
        //TODO: Allow this sequence to be broken. It can't be right now
        lineNode4?.runAction(inflateSequence) {
            lineNode2?.runAction(inflateSequence) {
                lineNode1?.runAction(inflateSequence) {
                    lineNode3?.runAction(inflateSequence) {
                        lineNode5?.runAction(inflateSequence)
                    }
                }
            }
        }

    }
    
    func alert() {
        //this is only last for now, may have to change it later
        //there's gotta be a better way to do this...
        let emoticonNode = geometryNode.childNodes.last
        let lineNode1 = emoticonNode?.childNodes[0]
        let lineNode2 = emoticonNode?.childNodes[1]
        let lineNode3 = emoticonNode?.childNodes[2]
        let lineNode4 = emoticonNode?.childNodes[3]
        let lineNode5 = emoticonNode?.childNodes[4]
        
        lineNode1?.runAction(SCNAction.scale(to: 1.5, duration: 0.1))
        
        lineNode2?.runAction(SCNAction.rotateTo(x: 0.0, y: 0.0, z: 0.0, duration: 0.1))
        lineNode2?.runAction(SCNAction.move(to: SCNVector3(0.0, 25.0, 0.0), duration: 0.1))
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.2
        let line1 = lineNode1?.geometry as! SCNBox
        let line2 = lineNode2?.geometry as! SCNBox
        let line3 = lineNode3?.geometry as! SCNBox
        let line4 = lineNode4?.geometry as! SCNBox
        let line5 = lineNode5?.geometry as! SCNBox
        line1.height = 2.0
        line2.height = 10.0
        line3.height = 4.0
        line4.height = 4.0
        line5.height = 6.0
        SCNTransaction.commit()
        
        lineNode3?.runAction(SCNAction.move(to: SCNVector3(9.0, 13.0, 0.0), duration: 0.1))
        lineNode3?.runAction(SCNAction.rotateTo(x: 0.0, y: 0.0, z: degreesToRadians(160), duration: 0.1))
        
        lineNode4?.runAction(SCNAction.move(to: SCNVector3(14.0, 6.0, 0.0), duration: 0.1))
        lineNode4?.runAction(SCNAction.rotateTo(x: 0.0, y: 0.0, z: degreesToRadians(100), duration: 0.1))
        
        lineNode5?.runAction(SCNAction.move(to: SCNVector3(13.0, 11.0, 0.0), duration: 0.1))
        lineNode5?.runAction(SCNAction.rotateTo(x: 0.0, y: 0.0, z: degreesToRadians(130), duration: 0.1))
    }
    
    func reset() {
        //this is only last for now, may have to change it later
        //there's gotta be a better way to do this...
        let emoticonNode = geometryNode.childNodes.last
        let lineNode1 = emoticonNode?.childNodes[0]
        let lineNode2 = emoticonNode?.childNodes[1]
        let lineNode3 = emoticonNode?.childNodes[2]
        let lineNode4 = emoticonNode?.childNodes[3]
        let lineNode5 = emoticonNode?.childNodes[4]
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.2
        for node in (emoticonNode?.childNodes)! {
            let prism = node.geometry as! SCNBox
            prism.height = 6.0
        }
        
        //3.0 is height / 2, but I really gotta decide how I'm gonna do scaling. Magic numbers are bad
        lineNode1?.scale = SCNVector3(1.0, 1.0, 1.0)
        lineNode1?.position = SCNVector3(0.0, 13.5 + 3.0, 0.0)
        
        lineNode2?.transform = SCNMatrix4MakeRotation(22.5, 0.0, 0.0, 1.0)
        lineNode2?.position = SCNVector3(-8.0, 11.5 + 3.0, 0.0)
        
        lineNode3?.transform = SCNMatrix4MakeRotation(-22.5, 0.0, 0.0, 1.0)
        lineNode3?.position = SCNVector3(8.0, 11.5 + 3.0, 0.0)
        
        lineNode4?.transform = SCNMatrix4MakeRotation(45.0, 0.0, 0.0, 1.0)
        lineNode4?.position = SCNVector3(-14.0, 6.0 + 3.0, 0.0)
        
        lineNode5?.transform = SCNMatrix4MakeRotation(-45.0, 0.0, 0.0, 1.0)
        lineNode5?.position = SCNVector3(14.0, 6.0 + 3.0, 0.0)
        
        SCNTransaction.commit()
        
    }
    
    @IBAction func onParticlesChanged(_ sender: UISlider) {
        particleSystem.particleSize = CGFloat(Float(13.0) * sender.value)
        particleSystem.particleColor = UIColor(red: 11/255, green: 152/255, blue: 232/255, alpha: CGFloat(sender.value))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testFile = URL(fileURLWithPath: Bundle.main.path(forResource: "whereisthepool", ofType: "wav")!)
        
        do{
            try player = AVAudioPlayer(contentsOf: testFile)
            player.isMeteringEnabled = true
            
        } catch {
            print("Error finding audio resource")
        }
        
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
        
        view.backgroundColor = UIColor.black
        setupScene()
    }
    
    func setupScene() {
        let scene = SCNScene()
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        scene.rootNode.addChildNode(omniLightNode)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 80)
        scene.rootNode.addChildNode(cameraNode)
        
        let mainNode = SCNNode()
        mainNode.addChildNode(createOrbit(10, color: randomColoredMaterial()))
        for _ in 1 ... 9 {
            let myRotation = randomRotation()
            mainNode.addChildNode(createOrbit(10, color:  randomColoredMaterial(), transform: myRotation))
        }
        
        mainNode.addChildNode(createEmoticon(randomColoredMaterial()))
        
        scene.rootNode.addChildNode(mainNode)
        
        mainNode.addParticleSystem(particleSystem)
        geometryNode = mainNode
        
        //TODO: Add full camera control, not just pan
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SceneKitViewController.panGesture(_:)))
        sceneView.addGestureRecognizer(panRecognizer)
        
        sceneView.backgroundColor = UIColor.black
        
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        
        //sceneView.allowsCameraControl = true
        sceneView.delegate = self
    }
    
    func createOrbit(_ radius: CGFloat, color: SCNMaterial, girth: CGFloat? = 0.5, transform: SCNMatrix4? = nil) -> SCNNode {
        
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
        
        if let _ = transform {
            ringNode.transform = transform!
        }
        
        return ringNode
    }
    
    func createEmoticon(_ color: SCNMaterial, height: CGFloat? = 6.0) -> SCNNode {
        //height may need to be something relative to radius. I don't wanna say 1/3 but it kinda looks like it might be...
        //chamferRadius can at most be half the width. If doing it with a box doens't work, will probably have to create a custom geometery from a UIBezierCurve
        let line1 = SCNBox(width: 2.0, height: height!, length: 2.0, chamferRadius: 5.0)
        line1.materials = [color]
        let lineNode1 = SCNNode(geometry: line1)
        //All these positions should be some function of radius and height
        lineNode1.position = SCNVector3(0.0, 13.5 + 0.5 * height!, 0.0)
        
        
        let line2 = SCNBox(width: 2.0, height: height!, length: 2.0, chamferRadius: 5.0)
        line2.materials = [color]
        let lineNode2 = SCNNode(geometry: line2)
        lineNode2.transform = SCNMatrix4MakeRotation(22.5, 0.0, 0.0, 1.0)
        lineNode2.position = SCNVector3(-8.0, 11.5 + 0.5 * height!, 0.0)
        
        let line3 = SCNBox(width: 2.0, height: height!, length: 2.0, chamferRadius: 5.0)
        line3.materials = [color]
        let lineNode3 = SCNNode(geometry: line3)
        lineNode3.transform = SCNMatrix4MakeRotation(-22.5, 0.0, 0.0, 1.0)
        lineNode3.position = SCNVector3(8.0, 11.5 + 0.5 * height!, 0.0)
        
        let line4 = SCNBox(width: 2.0, height: height!, length: 2.0, chamferRadius: 5.0)
        line4.materials = [color]
        let lineNode4 = SCNNode(geometry: line4)
        lineNode4.transform = SCNMatrix4MakeRotation(45.0, 0.0, 0.0, 1.0)
        lineNode4.position = SCNVector3(-14.0, 6.0 + 0.5 * height!, 0.0)
        
        let line5 = SCNBox(width: 2.0, height: height!, length: 2.0, chamferRadius: 5.0)
        line5.materials = [color]
        let lineNode5 = SCNNode(geometry: line5)
        lineNode5.transform = SCNMatrix4MakeRotation(-45.0, 0.0, 0.0, 1.0)
        lineNode5.position = SCNVector3(14.0, 6.0 + 0.5 * height!, 0.0)
        
        let emoticonNode = SCNNode()
        emoticonNode.addChildNode(lineNode1)
        emoticonNode.addChildNode(lineNode2)
        emoticonNode.addChildNode(lineNode3)
        emoticonNode.addChildNode(lineNode4)
        emoticonNode.addChildNode(lineNode5)
        
        return emoticonNode
    }
    
    func randomRotation() -> SCNMatrix4 {
        let randomTilt = Float(arc4random_uniform(UInt32(360)))
        let randomAxisX = Float(arc4random_uniform(UInt32(2)))
        let randomAxisY = Float(arc4random_uniform(UInt32(2)))
        let randomAxisZ = Float(arc4random_uniform(UInt32(2)))
        let rotation = SCNMatrix4MakeRotation(randomTilt, randomAxisX, randomAxisY, randomAxisZ)
        return rotation
    }
    
    func randomColoredMaterial() -> SCNMaterial {
        let myMat = SCNMaterial()
        myMat.diffuse.contents = makeRandomColor()
        return myMat
    }
    
    func makeRandomColor() -> UIColor {
        let randomR = CGFloat(arc4random_uniform(UInt32(101))) / 100.0
        let randomG = CGFloat(arc4random_uniform(UInt32(101))) / 100.0
        let randomB = CGFloat(arc4random_uniform(UInt32(101))) / 100.0
        return UIColor(red: randomR, green: randomG, blue: randomB, alpha: 1.0)
    }
    
    func degreesToRadians(_ degrees: Double) -> CGFloat {
        return CGFloat(degrees * M_PI / 180.0)
    }
    
    func panGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: sender.view!)
        var newAngle = (Float)(translation.x) * (Float)(M_PI)/180.0
        newAngle += currentAngle
        
        geometryNode.transform = SCNMatrix4MakeRotation(newAngle, 0, 1, 0)
        
        if( sender.state == UIGestureRecognizerState.ended) {
            currentAngle = newAngle
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SceneKitViewController : SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        //TODO: set birthrate/particleSize to 0 if no internet connection
        if player.isPlaying {
            player.updateMeters()
            particleSystem.particleSize = CGFloat(-1 / player.peakPower(forChannel: 0) * 50)
            print(player.peakPower(forChannel: 0))
            particleSystem.particleColor = UIColor(red: 11/255, green: 152/255, blue: 232/255, alpha: CGFloat(-1/player.peakPower(forChannel: 0) * 30))
        } else {
            //TODO: set particle to a reasonable size when not speaking
        }
    }
    
}
