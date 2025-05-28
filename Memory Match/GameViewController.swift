//
//  GameViewController.swift
//  Memory Match
//
//  Created by Pe Tia on 25.05.25.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
               let scene = LoadingScene(size: view.bounds.size) // check notification screen
//               let scene = NotificationScene(size: view.bounds.size)
               scene.scaleMode = .aspectFill
               view.presentScene(scene)
               view.ignoresSiblingOrder = true
           }
        
        }
    }

var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

var prefersStatusBarHidden: Bool {
        return true
    }

