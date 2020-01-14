//
//  ViewController.swift
//  ArDrawApp
//
//  Created by 小澤謙太郎 on 2020/01/11.
//  Copyright © 2020 小澤謙太郎. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    var touchedLocation:CGPoint = .zero
    var isTouching = false
    var existentNode: SCNNode?
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = (self as ARSCNViewDelegate)
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.scene = SCNScene()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = true
        guard let location = touches.first?.location(in: nil) else {
            return
        }
        touchedLocation = location
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: nil) else {
            return
        }
        touchedLocation = location
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = false
    }

    func createBallNode()-> SCNNode {
        let ball = SCNSphere(radius: 0.003)
        ball.firstMaterial?.diffuse.contents = UIColor.blue
        return SCNNode(geometry: ball)
    }
}
extension ViewController:ARSCNViewDelegate{
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard isTouching else {
            return
        }
        var ballNode = SCNNode()
        if let node = existentNode{
            _ = node.clone()
        }else{
            ballNode = createBallNode()
            existentNode = ballNode
        }
        let wordPostion = sceneView.unprojectPoint(SCNVector3(touchedLocation.x, touchedLocation.y, 0.995))
        ballNode.position = wordPostion
        sceneView.scene.rootNode.addChildNode(ballNode)
    }
}
