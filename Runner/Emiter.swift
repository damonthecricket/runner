//
//  Emitor.swift
//  Runner
//
//  Created by Damon Cricket on 27.01.2020.
//  Copyright © 2020 DC. All rights reserved.
//

import Foundation
import UIKit

protocol EmiterDelegate: class {
    func emiter(_ emiter: Emiter, didMoveView view: UIView)
}

class Emiter: Equatable {
    weak var delegate: EmiterDelegate?
    weak var view: UIView?
    var timer: Timer?
    var xOffset: CGFloat = 0.0
    var yOffset: CGFloat = 0.0
    var timeInterval: TimeInterval = 0.0
    
    deinit {
        stopTimer()
    }
    
    func start() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerTick(timer:)), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerTick(timer: Timer) {
        let size = view!.frame.size
        view?.frame = CGRect(x: view!.frame.minX + xOffset, y: view!.frame.minY + yOffset, width: size.width, height: size.height)
        delegate?.emiter(self, didMoveView: view!)
    }
    
    func stop() {
        stopTimer()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    static func ==(lhs: Emiter, rhs: Emiter) -> Bool {
        return lhs.view == rhs.view
    }
}
