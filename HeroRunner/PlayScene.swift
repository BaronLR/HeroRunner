import SpriteKit

class PlayScene: SKScene, SKPhysicsContactDelegate
{
    let runningBar = SKSpriteNode(imageNamed:"bar")
    let hero = SKSpriteNode(imageNamed:"hero")
    let block1 = SKSpriteNode(imageNamed:"block1")
    let block2 = SKSpriteNode(imageNamed:"block2")
    let scoreText = SKLabelNode()
    let debug = SKLabelNode()
    var width = CGFloat(0.0)
    var origRunningBarPositionX = CGFloat(0)
    var maxBarX = CGFloat(0)
    var heroBaseline = CGFloat(0)
    var velocityY = CGFloat(0)
    let gravity = CGFloat(0.35)
    var blockreset = CGFloat(0.0)
    var groundSpeed = CGFloat(0.0)
    var onGround = true
    var Falling = false
    var distanceTrav = 0
    var score = 0
    var blockMaxX = CGFloat(0)
    var origBlockPositionX = CGFloat(0)
    var Lives:UInt32 = 3
    
    enum Collider:UInt32 {
        case hero = 1
        case block = 2
    }
    
    override func didMoveToView(view: SKView) {
   
        self.backgroundColor = UIColor(hex: 0x64B5F6)
        self.physicsWorld.contactDelegate = self //allows reponse from collison detection
        
        self.block1.position = CGPointMake(CGRectGetMaxX(self.frame) + block1.size.width, self.heroBaseline + (self.block1.size.height/2))
        self.block2.position = CGPointMake(CGRectGetMaxX(self.frame) + block2.size.width, self.heroBaseline + (self.block2.size.height/2))
        block1.size.width = 75
        block1.size.height = 100
        block2.size.height = 200
        block2.size.width = 50
        
        //static = no move, dynamic = can move
        
        
       
        self.block1.name = "block1"
        self.block2.name = "block2"
        
        blockStatuses["block1"] = BlockStatus(isRunning: false, timeGap: random(), currentInterval: UInt32(0), thisBlockSizeHeight: block1.size.height)
        blockStatuses["block2"] = BlockStatus(isRunning: false, timeGap: random(), currentInterval: UInt32(0),thisBlockSizeHeight: block2.size.height)
        self.blockMaxX = 0 - block1.self.size.width
        self.origBlockPositionX = block1.self.position.x
        
        self.runningBar.anchorPoint = CGPointMake(0, 0.5)
        self.runningBar.position = CGPointMake(
            CGRectGetMinX(self.frame),
            CGRectGetMinY(self.frame) + (self.runningBar.size.height / 2))
        self.origRunningBarPositionX = self.runningBar.position.x
        self.maxBarX = self.runningBar.size.width - self.frame.size.width
        self.maxBarX *= -1
        self.heroBaseline = self.runningBar.position.y + (self.runningBar.size.height)/2
        self.hero.position = CGPointMake((CGRectGetMinX(self.frame) + runningBar.size.height), heroBaseline)
        self.hero.size.height = 70
        self.hero.size.width = 70
        
        
        self.debug.fontSize = 30
        self.debug.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 100)
        self.debug.fontColor = UIColor(hex: 0xFFFF00)
        
        
            //self.runningBar.physicsBody = SKPhysicsBody(rectangleOfSize: self.runningBar.size)
            //self.runningBar.physicsBody?.dynamic = false
        self.block1.physicsBody?.dynamic = false //It doesn't move on it's own//doesn't partake in phsyics
        self.hero.physicsBody?.dynamic = true
        
        self.scoreText.text = "0"
        self.scoreText.fontSize = 30
        self.scoreText.fontColor = UIColor(hex: 0xFF0000)
        self.scoreText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 20)

        
        self.hero.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(hero.size.width / 2))
        self.hero.physicsBody?.affectedByGravity = false //I made my own :/
        self.hero.physicsBody?.categoryBitMask = Collider.hero.rawValue
        self.hero.physicsBody?.contactTestBitMask = Collider.block.rawValue //What it can collide
        self.hero.physicsBody?.collisionBitMask = Collider.block.rawValue
        
        self.block1.physicsBody = SKPhysicsBody(rectangleOfSize: self.block1.size)
        self.block1.physicsBody?.dynamic = false //ITS A WALLLL
        self.block1.physicsBody?.categoryBitMask = Collider.block.rawValue
        self.block1.physicsBody?.contactTestBitMask = Collider.hero.rawValue //TESTS Collides with hero
        self.block1.physicsBody?.collisionBitMask = Collider.hero.rawValue
        
        self.block2.physicsBody = SKPhysicsBody(rectangleOfSize: self.block2.size)
        self.block2.physicsBody?.dynamic = false //ITS A WALLLL
        self.block2.physicsBody?.categoryBitMask = Collider.block.rawValue
        self.block2.physicsBody?.contactTestBitMask = Collider.hero.rawValue //TESTS Collides with hero
        self.block2.physicsBody?.collisionBitMask = Collider.hero.rawValue
        
        self.addChild(self.block1)
        self.addChild(self.block2)
        self.addChild(self.runningBar)
        self.addChild(self.hero)
        self.addChild(self.scoreText)
        self.addChild(self.debug)
    }
    
    func random() -> UInt32
    {
        var range = UInt32(50)...UInt32(200)
        return range.startIndex + arc4random_uniform(range.endIndex - range.startIndex + 1)
    }
    
    var blockStatuses:Dictionary<String,BlockStatus> = [:]
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        if self.onGround{
             velocityY = -18.0
             onGround = false
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent)
    {
        if velocityY <= -9 {
            velocityY = -9
        }
    }
    
    
    override func update(currentTime: NSTimeInterval)
    {
         self.scoreText.text =  " Lives:  " + Lives.description
        
         self.debug.text =  "Score: " + String(self.score)
        velocityY += gravity
        hero.position.y -= velocityY
        
        if hero.self.position.y < heroBaseline
        {
            self.hero.position.y   = heroBaseline
            velocityY = 0.0
            onGround =  true
        }
        
        //---->Debugging
       // self.debug.text = block1.position.x.description + "  " + block1.position.y.description
        
        
        //---->The Father You Go. The Faster You Roll :P
        groundSpeed = 3
        self.gravity == (1 * (hero.position.y / 10))
        blockRunner()
        
        
        //------>Moving The Bar (On Reset)
        if self.runningBar.position.x <= maxBarX
        {
            self.runningBar.position.x = self.origRunningBarPositionX
        }
        
        var degreeRotation = CDouble(self.groundSpeed) * M_PI / 180
        self.hero.zRotation -= CGFloat(degreeRotation)
        runningBar.position.x -= CGFloat(self.groundSpeed)
       // block1.position.x -=  CGFloat(self.groundSpeed)
       
    }
     func didBeginContact(contact: SKPhysicsContact)
    {
        Lives--
        if Lives == 0
        {
            died()
        }
    }
    
    func died()
    {
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene
        {
          let skView = self.view as SKView!
          skView.ignoresSiblingOrder = true
          scene.size = skView.bounds.size
          scene.scaleMode = .AspectFill
          skView.presentScene(scene)
          
        }
        
    }
    func blockRunner()
    {
        for (block, blockStatuses) in self.blockStatuses
        {
            var thisBlock = self.childNodeWithName(block)
            thisBlock?.position.y = heroBaseline + (blockStatuses.thisBlockSizeHeight/2)
            
            if blockStatuses.shouldRunBlock()
            {
                //Let's go boys!
                blockStatuses.timeGap = random()
                blockStatuses.currentInterval = 0
                blockStatuses.isRunning = true
            }
        
            if blockStatuses.isRunning == true
            {
                
                if thisBlock?.position.x > blockMaxX
                {
                    thisBlock?.position.x -= self.groundSpeed
                }
                else
                {
                    thisBlock?.position.x = self.origBlockPositionX
                    thisBlock?.position.y = self.runningBar.size.height
                    blockStatuses.isRunning = false
                   
                  score++
                   
                    if score % 5 == 0
                    {
                        groundSpeed++
                    }
                }
             }
            if blockStatuses.isRunning == false
            {
                blockStatuses.currentInterval++
            }
        }
    }
}






