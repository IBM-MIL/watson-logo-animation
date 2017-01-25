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
        nodeAgent_emoticon.alert()
    }
    
    @IBAction func onResetPressed(_ sender: AnyObject) {
        nodeAgent_emoticon.reset()
    }

    @IBAction func onAnimatePressed(_ sender: AnyObject) {
        nodeAgent_emoticon.think()
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
        
        nodeAgent_orbits.orbits().forEach {
            mainNode.addChildNode($0)
        }
        
//        mainNode.addChildNode()
//        for _ in 1 ... 9 {
//            let myRotation = randomRotation()
//            mainNode.addChildNode(createOrbit(10, color:  randomColoredMaterial(), transform: myRotation))
//        }
        
        let emoticonNode = nodeAgent_emoticon.createRootNode( IBMWLA_Random.randomColoredMaterial())!
        mainNode.addChildNode(emoticonNode)
        
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
    
    
    private let nodeAgent_emoticon = IBMWLA_SCNNodeAgent_Emoticon()
    private let nodeAgent_orbits = IBMWLA_SCNNodeAgent_Orbits()
//    func createEmoticon(_ color: SCNMaterial, height: CGFloat? = 6.0) -> SCNNode {
//        
//        return nodeAgent_emoticon.createRootNode(color, height: height!)!
//        
//    }
    
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
