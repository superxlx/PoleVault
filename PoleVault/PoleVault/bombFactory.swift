import SpriteKit
class bombFactory: SKSpriteNode {
    var bombimage:SKTexture!
    var scencewidth:CGFloat!
    var scenceheight:CGFloat!
    var bombheight:CGFloat!
    var bombwidth:CGFloat!
    var timer=NSTimer()
    func onInit(width:CGFloat,height:CGFloat,bounds:CGRect){
        self.timer.invalidate()
        self.scencewidth=width
        self.scenceheight=height
        self.bombheight=60/(bounds.height/768)
        self.bombwidth=60/(bounds.width/768)
        timer = NSTimer.scheduledTimerWithTimeInterval( 1, target: self, selector: "createBomb", userInfo: nil, repeats: true)
    }
    func createBomb(){
        var random = arc4random() % (UInt32)(scencewidth-bombwidth)
        var coloerandom = arc4random() % 4
        bombimage=SKTexture(imageNamed: "bomb_\(coloerandom)")
        var bomb=SKSpriteNode(texture:bombimage)
        bomb.size=CGSize(width: bombwidth, height: bombheight)
        bomb.position=CGPointMake((CGFloat)(random), scenceheight)
        bomb.anchorPoint=CGPoint(x: 0, y: 0)
        bomb.zPosition=40
        bomb.physicsBody=SKPhysicsBody(rectangleOfSize: bomb.size, center: CGPoint(x: bombwidth/2, y: bombheight/2))
        bomb.physicsBody!.allowsRotation=false
        bomb.physicsBody?.contactTestBitMask=BitMaskType.fence
        bomb.name="bombbomb"
        switch coloerandom{
        case 0:bomb.physicsBody!.categoryBitMask=BitMaskType.bluebomb
        case 1:bomb.physicsBody!.categoryBitMask=BitMaskType.yellowbomb
        case 2:bomb.physicsBody!.categoryBitMask=BitMaskType.redbomb
        case 3:bomb.physicsBody!.categoryBitMask=BitMaskType.greenbomb
        default:break
        }
        self.addChild(bomb)
    }
    func setspeed(speed:NSTimeInterval){
        self.timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval( speed, target: self, selector: "createBomb", userInfo: nil, repeats: true)
    }
    func cancelbomb(){
        self.timer.invalidate()
    }
}
