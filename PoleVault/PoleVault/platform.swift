import SpriteKit

class platform:SKSpriteNode {
    var SceneSize:CGSize!
    var distance:UInt32!
    var width:UInt32!
    var level=40
    var platform2:SKSpriteNode!
    func createplatform(size:CGSize){
        self.SceneSize=size
        var platform1=SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: self.SceneSize.width/3, height: self.SceneSize.height/4))
        platform1.anchorPoint=CGPoint(x: 0, y: 0)
        platform1.physicsBody=SKPhysicsBody(rectangleOfSize: platform1.size)
        platform1.physicsBody?.categoryBitMask=BitMaskType.platform
        platform1.physicsBody?.dynamic=false
        platform1.position=CGPointMake(0, 0)
        self.addChild(platform1)
        creatplatform2()
    }
    func creatplatform2(){
        self.width=arc4random()%(UInt32)(self.SceneSize.width/3)+self.level
        self.distance=arc4random()%((UInt32)(self.SceneSize.width/3*2)-self.width-20)+20
        platform2=SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: (CGFloat)(self.width), height: self.SceneSize.height/4))
        platform2.physicsBody=SKPhysicsBody(rectangleOfSize: platform2.size)
        platform2.physicsBody?.dynamic=false
        platform2.physicsBody?.categoryBitMask=BitMaskType.platform
        platform2.anchorPoint=CGPoint(x: 0, y: 0)
        platform2.position=CGPoint(x:self.SceneSize.width/3+(CGFloat)(self.distance), y: 0)
        self.addChild(platform2)
        
    }
    func compare(higher:CGFloat)->Bool{
        if higher>(CGFloat)(self.distance) && higher<(CGFloat)(self.distance+self.width) {
            self.re()
            return true
        }else{
            self.re()
            return false
        }
    }
    func cancelplatform2(){
        self.platform2.removeFromParent()
    }
    func re(){
        self.platform2.removeFromParent()
        creatplatform2()
    }
}
