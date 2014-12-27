//
//  BlockStatus.swift
//  HeroRunner
//
//  Created by Matt Falkner on 12/26/14.
//  Copyright (c) 2014 Matt Falkner. All rights reserved.
//

import Foundation

class BlockStatus //This is the block Initializer
{
    var isRunning = false
    var timeGapForNextRun = UInt32(0) //WOW INTS
    var currentInterval = UInt32(0)
   
    
    init(isRunning:Bool, timeGapForNextRun:UInt32, currentInterval:UInt32) {
        
        self.isRunning = isRunning
        self.timeGapForNextRun = timeGapForNextRun
        
        self.currentInterval = currentInterval
}
    
    func shouldRunBlock() -> Bool
    {
        return self.currentInterval > self.timeGapForNextRun
    }
}