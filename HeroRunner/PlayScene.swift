import SpriteKit

class PlayScene: SKScene, SKPhysicsContactDelegate
{
    
    //---->Let Statements
    let runningBar = SKSpriteNode(imageNamed:"bar")
    let hero = SKSpriteNode(imageNamed:"hero")
    let block1 = SKSpriteNode(imageNamed:"block1")
    let block2 = SKSpriteNode(imageNamed:"block2")
    let scoreText = SKLabelNode()
    let debug = SKLabelNode()
    
    //---->Floats
    var origRunningBarPositionX = CGFloat(0)
    var origBlockPositionX = CGFloat(0)
    var maxBarX = CGFloat(0)
    var heroBaseline = CGFloat(0)
    var velocityY = CGFloat(0)
    let gravity = CGFloat(0.6)

    
    //---->Other
    var groundSpeed = 0.0
    var onGround = true
    var Falling = false
    var distanceTrav = 0
    var score = 0
    
    //--->Blocks
    var numOfBlocks = 0
    var blocksOnScreen = 0;
    var BlockMaxX: Array<CGFloat> = []

    
    
    

    
    override func didMoveToView(view: SKView)
    {
        //--->BlockSetup
        block1.position.x = CGFloat(CGRectGetMaxX(self.frame) + block1.size.width)
        block2.position.x = CGFloat(CGRectGetMaxX(self.frame) + block2.size.width)
      //  self.blockMaxX = 0 - self.block1.size.width / 2
        
        
        
        
        
        //---->Important
        self.backgroundColor = UIColor(hex: 0x64B5F6)
        self.physicsWorld.contactDelegate = self
        
        //---->Running Bar
        self.runningBar.anchorPoint = CGPointMake(0, 0.5)
        self.runningBar.position = CGPointMake(
            CGRectGetMinX(self.frame),
            CGRectGetMinY(self.frame) + (self.runningBar.size.height / 2))
        self.origRunningBarPositionX = self.runningBar.position.x
        self.maxBarX = self.runningBar.size.width - self.frame.size.width
        self.maxBarX *= -1
        
        //---->Hero
        self.heroBaseline = self.runningBar.position.y + (self.runningBar.size.height)/2
        self.hero.position = CGPointMake((CGRectGetMinX(self.frame) + runningBar.size.height), heroBaseline)
        self.hero.size.height = 70
        self.hero.size.width = 70
        
        //---->Debug
        self.debug.fontSize = 18
        self.debug.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 200)
   
        //---->Block1,Block2
        self.block1.position = CGPointMake(CGRectGetMaxX(self.frame) + self.block1.size.width, self.heroBaseline)
        self.block2.position = CGPointMake(CGRectGetMaxX(self.frame) + self.block2.size.width, self.heroBaseline + (self.block1.size.height / 2))
        self.block1.physicsBody = SKPhysicsBody(rectangleOfSize: self.block1.size)
        self.block2.physicsBody = SKPhysicsBody(rectangleOfSize: self.block1.size)
        //This Should be the Same for all of the blocks that are added
        

        //---->Score Sysytem
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        //---->Adding To Form
        self.addChild(self.debug)
        self.addChild(self.runningBar)
        self.addChild(self.hero)
        self.addChild(self.scoreText)
        self.addChild(self.block1)
        self.addChild(self.block2)
        
    }

    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        velocityY = velocityY - 9
        onGround = false
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent)
    {
      velocityY = 9/gravity
    }
    
    override func update(currentTime: NSTimeInterval)
    {
        //---->Debugging
        self.debug.text = "Hero.Y = " + (hero.position.y).description + "  " + (hero.position.x).description + "  " + onGround.description
        
        
        //---->The Father You Go. The Faster You Roll :P
        distanceTrav++
        if distanceTrav % 2 ==  0
        {
            groundSpeed = (5.0 + (groundSpeed/10.0))
        }
        self.gravity == (1 * (hero.position.y / 10))
        
        
        //------>Moving The Bar (On Reset)
        if self.runningBar.position.x <= maxBarX
        {
            self.runningBar.position.x = self.origRunningBarPositionX
            
        }
        
        //----> Jumping
        if onGround == true
        {
            velocityY = 0
        }
        else
        {
            if hero.position.y < heroBaseline
            {
                onGround = true
                hero.position.y = heroBaseline
            }
            else
            {
                hero.position.y -= velocityY
                
            }
        }
        //---->BlocksMovemement/SPAWNNING
        
        
        var degreeRotation = CDouble(self.groundSpeed) * M_PI / 180
        self.hero.zRotation -= CGFloat(degreeRotation)
        runningBar.position.x -= CGFloat(self.groundSpeed)
        
    }
}
