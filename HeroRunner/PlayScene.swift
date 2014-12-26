import SpriteKit

class PlayScene: SKScene, SKPhysicsContactDelegate {
    
    let runningBar = SKSpriteNode(imageNamed:"bar")
    let hero = SKSpriteNode(imageNamed:"hero")
    let block1 = SKSpriteNode(imageNamed:"block1")
    let block2 = SKSpriteNode(imageNamed:"block2")
    let scoreText = SKLabelNode()
    let debug = SKLabelNode()
    var origRunningBarPositionX = CGFloat(0)
    var maxBarX = CGFloat(0)
    var groundSpeed = 5
    var heroBaseline = CGFloat(0)
    var onGround = true
    var velocityY = CGFloat(0)
    let gravity = CGFloat(0.6)
    
    var blockMaxX = CGFloat(0)

    var score = 0
 
    
    override func didMoveToView(view: SKView)
    {
        
        self.backgroundColor = UIColor(hex: 0x80D9FF)
        //This uses 'Apples' physics ... Wonderful
        self.physicsWorld.contactDelegate = self
        
        //This Changes The point on the running bar at which we reference
        self.runningBar.anchorPoint = CGPointMake(0, 0.5)// Now it's the middle left
        
        //Sets the running bars position to the bar at the bottom
        self.runningBar.position = CGPointMake(
            CGRectGetMinX(self.frame),
            CGRectGetMinY(self.frame) + (self.runningBar.size.height / 2))
        
        
        //Sets the origonal X for the runningbar
        self.origRunningBarPositionX = self.runningBar.position.x
        
        //This sets the bars maximum position before resetting
        self.maxBarX = self.runningBar.size.width - self.frame.size.width
        self.maxBarX *= -1
        
        //This sets the reset position for the hero. The ground level.
        self.heroBaseline = self.runningBar.position.y + (self.runningBar.size.height)
        
        //self.hero.position = CGPointMake(10,10)
        self.hero.position = CGPointMake((CGRectGetMinX(self.frame) + runningBar.size.height), 0)
        
        //Got this code online :/ , Should make the hero a "Phsycal Body" for interaction with blocks later
       // self.hero.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.hero.size.width / 2))
        
        //Debug settings
        self.debug.fontSize = 18
        self.debug.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 200)
        //Text Properties <--- Used for Scores
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        //Hero Properties
        self.hero.size.height = 50
        self.hero.size.width = 50
        
        //This Adds all of the objects to the form
        self.addChild(self.debug)
        self.addChild(self.runningBar)
        self.addChild(self.hero)
        self.addChild(self.scoreText)
        
    }

    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
 //----> An Override Function the checks when you touch the screen. When you do, it makes the velocity 
 //----> get higher and sets it so you are no longer on the ground
        if self.onGround
        {
            self.velocityY = 18.0
            self.onGround = false
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        //----> When you stop touching... You start falling
        
         self.velocityY -= 9.0 //Your velocity will fall my 9 until you reach the ground
         if self.hero.position.y < 0 //When he falls below 0
         {
            self.hero.position.y = self.heroBaseline  + hero.size.height//he is moved back
            self.onGround = true //He is on the ground
            
        }
        
    }
    
    override func update(currentTime: NSTimeInterval) { //Like the Timer from c#
        
        self.debug.text = "Hero.Y = " + (hero.position.y).description + "  " + (hero.position.x).description + "  " + onGround.description
       
        
        //------>  Resets the moving bar.
        if self.runningBar.position.x <= maxBarX
        {
            self.runningBar.position.x = self.origRunningBarPositionX
        }
        
        // ----> Continously checks to see if he has fallen below
        if self.hero.position.y < heroBaseline     //if it has fallen below the baseline
        {
            hero.position.y = self.heroBaseline  + hero.size.height //he is forced on the baseline
            velocityY = 0 //resets the velocity
            self.onGround = true //on the ground
            
        }

        //----->jumping
        if self.onGround == false
        {
            self.hero.position.y -= velocityY
            
            
        }
        else
        {
          hero.position.y = self.runningBar.size.height + hero.size.height
          self.hero.position.y = self.heroBaseline
          velocityY = 0.0

        }
        //sets the degree of rotation
        var degreeRotation = CDouble(self.groundSpeed) * M_PI / 180
        //rotate the hero
        self.hero.zRotation -= CGFloat(degreeRotation)
        //move the ground
        runningBar.position.x -= CGFloat(self.groundSpeed)
            }
        }
