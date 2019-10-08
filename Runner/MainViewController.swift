//
//  MainViewController.swift
//  Runner
//
//  Created by Damon Cricket on 07.10.2019.
//  Copyright © 2019 DC. All rights reserved.
//

import UIKit
import AudioToolbox

class MainViewController: UIViewController {
    
    struct Constants {
        static let jumpDuration: TimeInterval = 0.2
        static let runnerSize: CGFloat = 100.0
        static let blockSize: CGFloat = 100.0
    }
    
    var runnerView: UIView = UIView()
    var blockView: UIView = UIView()
    var onJump = false
    var isBlock = false

    override func viewDidLoad() {
        super.viewDidLoad()

        placeRunner()
        runnerView.backgroundColor = UIColor.green
        view.addSubview(runnerView)
        
        hideBlock()
        blockView.backgroundColor = UIColor.black
        view.addSubview(blockView)
        
        view.bringSubviewToFront(runnerView)
        
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(placeBlockTimerTick(timer:)), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(collideTimerTick(timer:)), userInfo: nil, repeats: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        placeRunner()
        
        if isBlock {
            placeBlock()
        } else {
            hideBlock()
        }
    }
    
    @IBAction func tapGestureRecognizer(sender: UITapGestureRecognizer) {
        if !onJump {
            onJump = true
            UIView.animate(withDuration: Constants.jumpDuration, animations: {
                self.runnerView.frame = CGRect(x: 0.0, y: self.view.bounds.height - CGFloat(300.0), width: Constants.runnerSize, height: Constants.runnerSize)
            }, completion: {isFinished in
                Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.jump(timer:)), userInfo: nil, repeats: false)
            })
        }
    }
    
    @objc func jump(timer: Timer) {
        UIView.animate(withDuration: Constants.jumpDuration, animations: {
            self.runnerView.frame = CGRect(x: 0.0, y: self.view.bounds.height - Constants.runnerSize, width: Constants.runnerSize, height: Constants.runnerSize)
        }, completion: {isFinished in
            self.onJump = false
        })
    }
    
    @objc func placeBlockTimerTick(timer: Timer) {
        placeBlock()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(runBlockTimerTick(timer:)), userInfo: nil, repeats: false)
    }
    
    @objc func runBlockTimerTick(timer: Timer) {
        UIView.animate(withDuration: 1.0, animations: {
            self.blockView.frame = CGRect(x: -Constants.blockSize, y: self.view.bounds.height - Constants.blockSize, width: Constants.blockSize, height: Constants.blockSize)
        }, completion: {isFinished in
            self.hideBlock()
        })
    }
    
    @objc func collideTimerTick(timer: Timer) {
        print("runner frame = \(runnerView.frame), block frame = \(blockView.frame)")
    }
    
    private func placeRunner() {
        runnerView.frame = CGRect(x: 0.0, y: view.bounds.height - Constants.runnerSize, width: Constants.runnerSize, height: Constants.runnerSize)
    }
    
    private func placeBlock() {
        blockView.frame = CGRect(x: view.bounds.width - Constants.blockSize, y: view.bounds.height - Constants.blockSize, width: Constants.blockSize, height: Constants.blockSize)
        isBlock = true
    }
    
    private func hideBlock() {
        blockView.frame = CGRect(x: view.bounds.width, y: view.bounds.height - Constants.blockSize, width: Constants.blockSize, height: Constants.blockSize)
        isBlock = false
    }
}
