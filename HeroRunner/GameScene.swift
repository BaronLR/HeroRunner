//
//  GameScene.swift
//  HeroRunner
//
//  Created by Matt Falkner on 12/24/14.
//  Copyright (c) 2014 Matt Falkner. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let playButton = SKSpriteNode(imageNamed:"play")
    
    override func didMoveToView(view: SKView)
    {
        self.playButton.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))
        self.addChild(self.playButton)
        self.playButton.size.height = 150
        self.playButton.size.width = 150
        self.backgroundColor = UIColor(hex: 0xFFFFFF)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        for touch: AnyObject in touches
        {
            //Grabs location at where they touched
            let location = touch.locationInNode(self)
            self.nodeAtPoint(location)
            
            if self.nodeAtPoint(location) == self.playButton{
                println("We Are Heading To The Game!")
                var scene = PlayScene(size: self.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene)
                
            
            }
        }
        
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
