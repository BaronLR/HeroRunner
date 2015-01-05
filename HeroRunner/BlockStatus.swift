//
//  BlockStatus.swift
//  HeroRunner
//
//  Created by Matt Falkner on 1/4/15.
//  Copyright (c) 2015 Matt Falkner. All rights reserved.
//

import Foundation
import SpriteKit

class BlockStatus {
    
    var isRunning = false
    var timeGap = UInt32(0)
    var currentInterval = UInt32(0) //How Long Has Waited since last placement
    var thisBlockSizeHeight = CGFloat(0)
    
    init(isRunning:Bool, timeGap:UInt32, currentInterval:UInt32, thisBlockSizeHeight:CGFloat){ //Adds an Initizating value for Blocks
        self.isRunning = isRunning
        self.timeGap = timeGap
        self.currentInterval = currentInterval
        self.thisBlockSizeHeight = thisBlockSizeHeight
    }
    
    func shouldRunBlock() -> Bool {   //If it's been waiting for longer than the time gap
      return self.currentInterval > self.timeGap
    }
    
}