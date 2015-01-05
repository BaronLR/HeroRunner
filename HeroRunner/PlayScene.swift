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
    
    override func didMoveToView(view: SKView) {
   
        self.backgroundColor = UIColor(hex: 0x64B5F6)
        self.physicsWorld.contactDelegate = self
        self.block1.position = CGPointMake(CGRectGetMaxX(self.frame) + block1.size.width, self.heroBaseline + (self.block1.size.height))
        self.block2.position = CGPointMake(CGRectGetMaxX(self.frame) + block2.size.width, self.heroBaseline + (self.block2.size.height))
        block1.size.width = 200
        block1.size.height = 200
        block2.size.height = 200
        block2.size.width = 200
        
        self.addChild(self.block1)
        self.addChild(self.block2)
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
        self.debug.fontSize = 18
        self.debug.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 200)
        self.runningBar.physicsBody = SKPhysicsBody(rectangleOfSize: self.runningBar.size)
        self.runningBar.physicsBody?.dynamic = false
        self.block1.physicsBody?.dynamic = false //It doesn't move on it's own//doesn't partake in phsyics
        self.hero.physicsBody?.dynamic = true
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
     //self.addChild(self.debug)
        self.addChild(self.runningBar)
        self.addChild(self.hero)
        self.addChild(self.scoreText)
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
       
        velocityY += gravity
        hero.position.y -= velocityY
        
        if hero.self.position.y < heroBaseline
        {
            self.hero.position.y   = heroBaseline
            velocityY = 0.0
            onGround =  true
        }
        
        //---->Debugging
        self.debug.text = block1.position.x.description + "  " + block1.position.y.description
        
        
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
    
    func blockRunner()
    {
        for (block, blockStatuses) in self.blockStatuses
        {
            var thisBlock = self.childNodeWithName(block)
            
            if blockStatuses.shouldRunBlock()
            {
                //Let's go boys!
                blockStatuses.timeGap = random()
                blockStatuses.currentInterval = 0
                blockStatuses.isRunning = true
            }
        
            if blockStatuses.isRunning == true
            {
                thisBlock?.position.y = runningBar.size.height + blockStatuses.thisBlockSizeHeight
                if thisBlock?.position.x > blockMaxX
                {
                    thisBlock?.position.x -= self.groundSpeed
                }
                else
                {
                    thisBlock?.position.x = self.origBlockPositionX
                    thisBlock?.position.y = self.runningBar.size.height
                    blockStatuses.isRunning = false
                   // self.score.hashValue ++
                
                  //self.scoreText.text = String(self.score)
                }
             }
            if blockStatuses.isRunning == false
            {
                blockStatuses.currentInterval++
            }
        }
    }
}






