//
//  playScene.swift
//  PoleVault
//
//  Created by xlx on 15/3/8.
//  Copyright (c) 2015年 xlx. All rights reserved.
//
import SpriteKit

class playScene: SKScene,SKPhysicsContactDelegate,GDTMobInterstitialDelegate,reset{
    var polebottom:UIView!
    var pole:UIView!
    var plat=platform()
    var bomb=bombFactory()
    var polestate=false
    let action=SKAction.rotateByAngle(-(CGFloat)(M_PI/2), duration: 0.5)
    var score=0
    var scorebottom:UIView!
    var scorelabel:UILabel!
    var endview=endScene()
    var restate=true
    var time=3
    var timelabel:UILabel!
    var timer:NSTimer!
    var dongstate=true
    var _interstitialObj:GDTMobInterstitial!
    var AdState=false
    var myStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    var anotherView:endScene!
    var adcount:Int!
    override func didMoveToView(view: SKView) {
        anotherView=myStoryBoard.instantiateViewControllerWithIdentifier("post") as endScene
        anotherView.resetdelegate=self
        self.removeAllChildren()
        self.view?.userInteractionEnabled=false
        self.view?.showsFPS=false
        self.view?.showsNodeCount=false
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -1)
        self.name="scene"
        let skyColor = SKColor(red:241/255,green:215/255,blue:180/255,alpha:1)
        self.backgroundColor = skyColor
        var bombcount=self.score/5+1
        bomb.onInit(self.size.width,height: self.size.height,bounds: self.view!.bounds)
        self.addChild(bomb)
        plat.createplatform(self.size)
        self.addChild(plat)
        build()
        loadAd()
    }
    func rebuild() {
        println("rebuild")
        self.restate=true
        self.dongstate=true
        self.polestate=false
        self.view?.userInteractionEnabled=true
        var bombcount=self.score/5+1
        self.bomb=bombFactory()
        bomb.onInit(self.size.width,height: self.size.height,bounds: self.view!.bounds)
        self.addChild(bomb)
        self.plat.cancelplatform2()
        plat.createplatform(self.size)
        self.addChild(plat)
        self.view!.addSubview(self.scorebottom)
        self.score=0
        self.time=4
        self.timelabel.text="\(self.time)"
        self.scorelabel.text="\(self.score)"
        var fence=SKSpriteNode(imageNamed: "虚线.png")
        fence.anchorPoint=CGPoint(x: 0, y: 0)
        fence.size=CGSize(width: self.size.width, height: 10)
        fence.position=CGPoint(x: 0, y: self.size.height/3*2)
        fence.physicsBody=SKPhysicsBody(rectangleOfSize: fence.size,center:CGPoint(x: self.size.width/2, y: 0))
        fence.physicsBody!.categoryBitMask=BitMaskType.fence
        fence.physicsBody!.dynamic=false
        fence.name="fence"
        self.addChild(fence)
        self.re()
        loadAd()
    }
    func build(){
        var minseconds=0.4*Double(NSEC_PER_SEC)
        var dtime=dispatch_time(DISPATCH_TIME_NOW, Int64(minseconds))
        dispatch_after(dtime,dispatch_get_main_queue(),{
            self.polebottom=UIView(frame:CGRectMake(self.view!.bounds.width/3-10,self.view!.bounds.height/4*3-9,10,10))
            self.view?.addSubview(self.polebottom)
            self.pole=UIView(frame: CGRectMake(0, 0, 10, 10))
            self.pole.backgroundColor=UIColor.blackColor()
            self.polebottom.addSubview(self.pole)
            self.scorebottom=UIView(frame: CGRectMake(self.view!.bounds.width/4*3, self.view!.bounds.height/3, self.view!.bounds.width/3, 30))
            self.view!.addSubview(self.scorebottom)
            var scoreimage=UIImageView(frame: CGRectMake(0, 0, self.view!.bounds.width/8, 30))
            scoreimage.image=UIImage(named: "score.png")
            self.scorebottom.addSubview(scoreimage)
            self.scorelabel=UILabel(frame: CGRectMake(self.view!.bounds.width/8, 0, self.view!.bounds.width/8, 30))
            self.scorelabel.text="\(self.score)"
            self.scorelabel.textAlignment=NSTextAlignment.Center
            self.scorebottom.addSubview(self.scorelabel)
            self.view?.userInteractionEnabled=true
            var timeimage=UIImageView(frame: CGRectMake(0, 30, self.view!.bounds.width/8, 30))
            timeimage.image=UIImage(named: "surplustime.png")
            self.scorebottom.addSubview(timeimage)
            self.timelabel=UILabel(frame: CGRectMake(self.view!.bounds.width/8, 30, self.view!.bounds.width/8, 30))
            self.timelabel.text="\(self.time)"
            self.timelabel.textAlignment=NSTextAlignment.Center
            self.scorebottom.addSubview(self.timelabel)
            self.timer=NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "increaseTime", userInfo: nil, repeats: true)
        })
        var fence=SKSpriteNode(imageNamed: "虚线.png")
        fence.anchorPoint=CGPoint(x: 0, y: 0)
        fence.size=CGSize(width: self.size.width, height: 10)
        fence.position=CGPoint(x: 0, y: self.size.height/3*2)
        fence.physicsBody=SKPhysicsBody(rectangleOfSize: fence.size,center:CGPoint(x: self.size.width/2, y: 0))
        fence.physicsBody!.categoryBitMask=BitMaskType.fence
        fence.physicsBody!.dynamic=false
        fence.name="fence"
        self.addChild(fence)
    }
    func increaseTime(){
        self.time=self.time-1
        timelabel.text="\(self.time)"
        if self.time == -1 {
            self.timer.invalidate()
            self.ended()
        }
    }
    func re(){
        if dongstate {
        self.polebottom.removeFromSuperview()
        self.pole.removeFromSuperview()
        polebottom=UIView(frame:CGRectMake(self.view!.bounds.width/3-10,self.view!.bounds.height/4*3-9,10,10))
        self.view!.addSubview(polebottom)
        pole=UIView(frame: CGRectMake(0, 0, 10, 10))
        pole.backgroundColor=UIColor.blackColor()
        self.polebottom.addSubview(pole)
        var speed=(NSTimeInterval)(1-(CGFloat)(self.score)/70)
        if speed<0.3 {
            speed=0.3
        }
        self.bomb.setspeed(speed)
        timer.invalidate()
        self.time=3
        self.timelabel.text="\(self.time)"
        self.timer=NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "increaseTime", userInfo: nil, repeats: true)
        }
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch : UITouch = touches.anyObject() as UITouch
        let touchedNode = nodeAtPoint(touch.locationInNode(self))
        if touchedNode.name=="bombbomb" {
            if touchedNode.physicsBody?.categoryBitMask==BitMaskType.bluebomb{
            }else if touchedNode.physicsBody?.categoryBitMask==BitMaskType.yellowbomb{
                self.score++
                self.scorelabel.text="\(self.score)"
            }else if touchedNode.physicsBody?.categoryBitMask==BitMaskType.greenbomb{
                self.score+=2
                self.scorelabel.text="\(self.score)"
            }else if touchedNode.physicsBody?.categoryBitMask==BitMaskType.redbomb{
            }
            runAction(SKAction.sequence([SKAction.playSoundFileNamed("bo.wav", waitForCompletion: false)]))
            touchedNode.removeFromParent()
        }else{
            if touch.locationInNode(self).y < self.size.height/3*2{
            polestate=true
            }
        }
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let touch : UITouch = touches.anyObject() as UITouch
        if touch.locationInNode(self).y < self.size.height/3*2{
         if polestate{
            polestate=false
            gradualchange_rotation(50, 90, self.polebottom)
            self.view!.userInteractionEnabled=false
            var minseconds=0.4*Double(NSEC_PER_SEC)
            var dtime=dispatch_time(DISPATCH_TIME_NOW, Int64(minseconds))
            dispatch_after(dtime,dispatch_get_main_queue(),{
                self.view!.userInteractionEnabled=true
                self.bomb.cancelbomb()
                var higher=self.pole.frame.size.height-10
                higher=higher/(self.view!.bounds.width/1024)
                if self.plat.compare(higher) {
                    if self.restate {
                        self.re()
                    }
                    self.score++
                    self.scorelabel.text="\(self.score)"
                }else{
                    self.runAction(SKAction.sequence([SKAction.playSoundFileNamed("lose.mp3", waitForCompletion: false)]))
                    self.ended()
                }
            })
        }
        }
    }
    override func update(currentTime: CFTimeInterval) {
        if polestate {
            pole.bounds.size.height+=3
            polebottom.bounds.size.height+=3
        }
    }
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.node?.name=="bombbomb" {
            if contact.bodyA.node!.physicsBody!.categoryBitMask == BitMaskType.greenbomb{
                contact.bodyA.node!.removeFromParent()
            }else if contact.bodyA.node!.physicsBody!.categoryBitMask == BitMaskType.redbomb{
                contact.bodyA.node!.removeFromParent()
                self.removeAllChildren()
                self.polebottom.removeFromSuperview()
                self.pole.removeFromSuperview()
                runAction(SKAction.sequence([SKAction.playSoundFileNamed("dong.mp3", waitForCompletion: false)]))
                self.dongstate=false
                var minseconds=0*Double(NSEC_PER_SEC)
                self.bomb.cancelbomb()
                var dtime=dispatch_time(DISPATCH_TIME_NOW, Int64(minseconds))
                dispatch_after(dtime,dispatch_get_main_queue(),{
                    self.ended()
                })
                
            }else if contact.bodyA.node!.physicsBody!.categoryBitMask == BitMaskType.yellowbomb{
                contact.bodyA.node!.removeFromParent()
            }else if contact.bodyA.node!.physicsBody!.categoryBitMask == BitMaskType.bluebomb{
                contact.bodyA.node!.removeFromParent()
            }
            

        }else{
            if contact.bodyB.node!.physicsBody!.categoryBitMask == BitMaskType.greenbomb{
                contact.bodyB.node!.removeFromParent()
            }else if contact.bodyB.node!.physicsBody!.categoryBitMask == BitMaskType.redbomb{
                contact.bodyB.node!.removeFromParent()
                self.removeAllChildren()
                self.polebottom.removeFromSuperview()
                self.pole.removeFromSuperview()
                runAction(SKAction.sequence([SKAction.playSoundFileNamed("dong.mp3", waitForCompletion: false)]))
                self.dongstate=false
                var minseconds=0*Double(NSEC_PER_SEC)
                self.bomb.cancelbomb()
                var dtime=dispatch_time(DISPATCH_TIME_NOW, Int64(minseconds))
                dispatch_after(dtime,dispatch_get_main_queue(),{
                    self.ended()
                })
                
            }else if contact.bodyB.node!.physicsBody!.categoryBitMask == BitMaskType.yellowbomb{
                contact.bodyB.node!.removeFromParent()
            }else if contact.bodyB.node!.physicsBody!.categoryBitMask == BitMaskType.bluebomb{
                contact.bodyB.node!.removeFromParent()
            }

        }
        
    }
    func ended(){
        println("end")
        if restate {
        restate=false
        self.removeAllChildren()
        self.plat.cancelplatform2()
        self.polebottom.removeFromSuperview()
        self.scorebottom.removeFromSuperview()
        self.timer.invalidate()
        self.bomb.removeFromParent()
        self.plat.removeFromParent()
            
            NSUserDefaults.standardUserDefaults().setObject(self.score, forKey: "score")
            UIApplication.sharedApplication().keyWindow?.rootViewController!.presentedViewController!.presentViewController(anotherView, animated: true, completion: nil)
            anotherView._interstitialObj=self._interstitialObj
        }
        println("show endscene")
       
    }
    func showad(){
        _interstitialObj.delegate=self
        var vc:UIViewController!=UIApplication.sharedApplication().keyWindow?.rootViewController
        var topVC = UIApplication.sharedApplication().keyWindow?.rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        vc=vc.presentedViewController!
        _interstitialObj.presentFromRootViewController(vc)
    }
    func loadAd(){
        _interstitialObj = GDTMobInterstitial(appkey: "1104208446", placementId: "5000104173338725")
        _interstitialObj.delegate = self
        _interstitialObj.isGpsOn = true     //【可选】设置GPS开关
        _interstitialObj.loadAd()
    }
    func interstitialSuccessToLoadAd(interstitial: GDTMobInterstitial!) {
        println("Success Loaded.")
        self.AdState=true
    }
    func interstitialFailToLoadAd(interstitial: GDTMobInterstitial!, errorCode: Int32) {
        println("Fail Loaded")
        self.loadAd()
    }
}
 