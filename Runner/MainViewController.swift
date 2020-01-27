//
//  MainViewController.swift
//  Runner
//
//  Created by Damon Cricket on 07.10.2019.
//  Copyright © 2019 DC. All rights reserved.
//

import UIKit
import AudioToolbox

class MainViewController: UIViewController, EmiterDelegate {
    struct Constants {
        static let runnerSize: CGFloat = 50.0
        static let blockSize: CGFloat = 100.0
    }
    
    @IBOutlet weak var blindView: UIView?
    @IBOutlet weak var startButton: UIButton?
    
    var runnerView = UIView()
    var blockView = UIView()
    var runnerEmiter = Emiter()
    var blockEmiter = Emiter()
    var onJump: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton?.layer.borderColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
        startButton?.layer.borderWidth = 2.0
        startButton?.layer.cornerRadius = 3.0
        
        placeRunner()
        runnerView.backgroundColor = .black
        view.addSubview(runnerView)
        
        placeBlock()
        blockView.backgroundColor = .red
        view.addSubview(blockView)
        
        runnerEmiter.view = runnerView
        runnerEmiter.yOffset = -1.0
        runnerEmiter.timeInterval = 0.001
        runnerEmiter.delegate = self
        
        blockEmiter.view = blockView
        blockEmiter.xOffset = -1.0
        blockEmiter.timeInterval = 0.001
        blockEmiter.delegate = self
    }
    
    @IBAction func startButtonTap(sender: UIButton) {
        blindView?.isHidden = true
        blockEmiter.start()
    }
    
    @IBAction func tapGestureRecognizer(sender: UITapGestureRecognizer) {
        if !onJump {
            onJump = true
            runnerEmiter.start()
        }
    }
    
    func emiter(_ emiter: Emiter, didMoveView v: UIView) {
        if runnerView.frame.minY < 0.0 {
            runnerEmiter.yOffset = 1.0
        } else if runnerView.frame.maxY > view.bounds.height && onJump {
            runnerEmiter.stop()
            placeRunner()
            runnerEmiter.yOffset = -1.0
            onJump = false
        }
        
        if runnerView.frame.intersects(blockView.frame) {
            runnerEmiter.stop()
            blockEmiter.stop()
            placeRunner()
            placeBlock()
            onJump = false
            blindView?.isHidden = false
        }
        
        if blockView.frame.maxX < 0.0 {
            placeBlock()
        }
    }
    
    func placeRunner() {
        runnerView.frame = CGRect(x: 0.0, y: view.bounds.height - Constants.runnerSize, width: Constants.runnerSize, height: Constants.runnerSize)
    }
    
    func placeBlock() {
        blockView.frame = CGRect(x: view.bounds.width, y: view.bounds.height - Constants.blockSize, width: Constants.blockSize, height: Constants.blockSize)
    }
}
