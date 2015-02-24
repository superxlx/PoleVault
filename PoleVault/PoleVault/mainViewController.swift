//
//  mainViewController.swift
//  PoleVault
//
//  Created by xlx on 15/2/1.
//  Copyright (c) 2015年 xlx. All rights reserved.
//

import UIKit
import AVFoundation
protocol sendMessageDelegate : NSObjectProtocol{
    
    func changeMesgScene(secene:Int32);
    func senderLinkContent();
    
    
}

class mainViewController: UIViewController,GDTMobInterstitialDelegate,sendMessageDelegate,WXApiDelegate{
    /////////////////////////////////////
    var isfirstLaugh=false
    var downurl:String="https://itunes.apple.com/us/app/polevault/id964481943?mt=8&ign-mpt=uo%3D4"
    ////////////////////////////////////
    var losePlayer:AVAudioPlayer!
    var _interstitialObj:GDTMobInterstitial!
    var background:UIImageView!
    var backnumber=arc4random()%41+1
    var statenumber=0
    var timer:NSTimer!
    var touchtimer:NSTimer!
    var state:UILabel!
    var score=0
    var sendscore=0
    var scoreview:UILabel!
    var polebottom:UIView!
    var pole:UIView!
    var platform:plate!
    var failuerview:UIView!
    var historyscore=0
    var isplay=true
    var sharelayout:UIView!
    var lay:UIView!
    var lay2:UIView!
    var tapSingle:UITapGestureRecognizer!
    var senceType: Int32?
    var delegate:sendMessageDelegate!
    var alertView:UIAlertView?
    var Adnumber=0
    var AdState=false
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAd()
        self.background=UIImageView(frame: self.view.frame)
        self.background.image=UIImage(named: "background_"+"\(backnumber)"+".JPG")
        self.view.addSubview(background)
        state=UILabel(frame: CGRectMake(0, 0, 170, 20))
        state.text="触摸屏幕能使跳杆变长"
        state.textColor=UIColor.whiteColor()
        state.center=self.view.center
        state.center.y=self.view.center.y-70
        self.view.addSubview(state)
        timer=NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "statedisapper", userInfo: nil, repeats: true)
        build()
        createAlertView()
        delegate=self
        WXApi.registerApp("wxeac5c9dd2a8e9411")
    }
    func statedisapper(){
      statenumber++
      if statenumber==3{
        timer.invalidate()
        gradualchange_alpha(1, 0, state)
    }
    }
    func build(){
        polebottom=UIView(frame:CGRectMake(self.view.bounds.width/3-10,self.view.bounds.height/4*3-9,10,10))
        self.view.addSubview(polebottom)
        pole=UIView(frame: CGRectMake(0, 0, 10, 10))
        pole.layer.cornerRadius=3
        pole.backgroundColor=UIColor.blackColor()
        self.polebottom.addSubview(pole)
        scoreview=UILabel(frame: CGRectMake(0, 0, 200, 200))
        self.view.addSubview(scoreview)
        scoreview.center=self.view.center
        scoreview.center.y-=100
        self.scoreview.text="\(score)"
        self.scoreview.font=UIFont(name: "Zapfino", size: 30)
        self.scoreview.textColor=UIColor.greenColor()
        self.scoreview.adjustsFontSizeToFitWidth=true
        self.scoreview.textAlignment=NSTextAlignment.Center
        crateplate()
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if isplay {
        touchtimer=NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "higher", userInfo: nil, repeats: true)
        }
    }
    func higher(){
        pole.bounds.size.height+=2
        polebottom.bounds.size.height+=2
    }
    func change_back(){
        if backnumber==40 {
            backnumber=1
        }
        var backimage="background_"+"\(backnumber)"+".JPG"
        self.background.image=UIImage(named: backimage)
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if isplay {
        touchtimer.invalidate()
        self.view.userInteractionEnabled=false
        gradualchange_rotation(25, 90, self.polebottom)
        var minseconds=1*Double(NSEC_PER_SEC)
        var dtime=dispatch_time(DISPATCH_TIME_NOW, Int64(minseconds))
        dispatch_after(dtime,dispatch_get_main_queue(),{
            var higher=self.pole.frame.size.height-10
            if self.platform.compare(higher) {
              self.succssful()
                self.platform.re(self.score)
                self.re()
            }else{
              self.failuer()
            }
        })
        }
        
    }
    func re(){
        self.polebottom.removeFromSuperview()
        self.pole.removeFromSuperview()
        polebottom=UIView(frame:CGRectMake(self.view.bounds.width/3-10,self.view.bounds.height/4*3-9,10,10))
        self.view.addSubview(polebottom)
        pole=UIView(frame: CGRectMake(0, 0, 10, 10))
        pole.layer.cornerRadius=3
        pole.backgroundColor=UIColor.blackColor()
        self.polebottom.addSubview(pole)
    }
    func succssful(){
        self.score+=1
        self.scoreview.text="\(self.score)"
    }
    func failuer(){
            loseplay()
            self.sendscore=self.score
            self.isplay=false
            self.view.userInteractionEnabled=true
            self.failuerview=UIView(frame: self.view.frame)
            self.view.addSubview(self.failuerview)
            var a=UIImageView(frame: self.view.frame)
            a.image=UIImage(named: "a.jpg")
            self.failuerview.addSubview(a)
            a.alpha=0.05
            self.failuerview.backgroundColor=UIColor.whiteColor()
            var faillabel=UILabel(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height/3))
            faillabel.text="结束!"
            faillabel.textColor=UIColor.redColor()
            faillabel.textAlignment=NSTextAlignment.Center
            self.failuerview.addSubview(faillabel)
            faillabel.adjustsFontSizeToFitWidth=true
            faillabel.font=UIFont(name: "Zapfino", size: 50)
            if let a: AnyObject = NSUserDefaults.standardUserDefaults().valueForKey("historyscore"){
                self.historyscore=a as Int
            }
            if self.score>self.historyscore {
                self.historyscore=self.score
                NSUserDefaults.standardUserDefaults().setObject(self.historyscore, forKey: "historyscore")
                faillabel.text="新纪录!"
            }
            var his=UILabel(frame: CGRectMake(0, self.view.bounds.height/3, self.view.bounds.width/2,30))
            var hissco=UILabel(frame: CGRectMake(self.view.bounds.width/2, self.view.bounds.height/3, self.view.bounds.width/2, 30))
            var sco=UILabel(frame: CGRectMake(0, self.view.bounds.height/3+40, self.view.bounds.width/2,30))
            var scor=UILabel(frame: CGRectMake(self.view.bounds.width/2, self.view.bounds.height/3+40, self.view.bounds.width/2, 30))
            scor.text="\(self.score)"
            hissco.text="\(self.historyscore)"
            self.failuerview.addSubview(his)
            self.failuerview.addSubview(sco)
            self.failuerview.addSubview(scor)
            self.failuerview.addSubview(hissco)
            his.text="历史最高分："
            sco.text="分数："
            var evalueate=UIButton(frame: CGRectMake(0, self.view.bounds.height/3*2,self.view.bounds.width/3, 30))
            evalueate.setImage(UIImage(named: "评分.png"), forState: UIControlState.Normal)
            self.failuerview.addSubview(evalueate)
            var re=UIButton(frame: CGRectMake(0, self.view.bounds.height/3*2+40, self.view.bounds.width/3, 30))
            re.setImage(UIImage(named: "开始.png"), forState: UIControlState.Normal)
            self.failuerview.addSubview(re)
            var share=UIButton(frame: CGRectMake(0, self.view.bounds.height/3*2+80, self.view.bounds.width/3, 30))
            share.setImage(UIImage(named: "分享.png"), forState: UIControlState.Normal)
            self.failuerview.addSubview(share)
            self.score=0
            self.scoreview.text="\(self.score)"
            his.textAlignment=NSTextAlignment.Right
            sco.textAlignment=NSTextAlignment.Right
            scor.textAlignment=NSTextAlignment.Left
            evalueate.center.x=self.view.center.x
            re.center.x=self.view.center.x
            re.addTarget(self, action: "again", forControlEvents: UIControlEvents.TouchUpInside)
            share.center.x=self.view.center.x
            share.addTarget(self, action: "WXFX", forControlEvents: UIControlEvents.TouchUpInside)
            self.failuerview.alpha=0
            gradualchange_alpha(0.5, 1, self.failuerview)
            evalueate.addTarget(self, action: "vaule", forControlEvents: UIControlEvents.TouchUpInside)
            self.Adnumber+=1
            if self.Adnumber>=3{
                if self.AdState {
                    self.showAd()
                }
            }

     }
    func vaule(){
            UIApplication.sharedApplication().openURL(NSURL(string: self.downurl)!)
    }
    func again(){
        if self.Adnumber>=3{
            if self.AdState {
                self.Adnumber=0
                self.loadAd()
            }
        }
        gradualchange_alpha(1, 0, self.failuerview)
        self.platform.re(score)
        self.re()
        self.backnumber++
        self.change_back()
        isplay=true
    }
    func WXFX(){
        self.sharelayout=UIView(frame: self.view.frame)
        self.view.addSubview(sharelayout)
        
        lay=UIView(frame: self.view.frame)
        self.sharelayout.addSubview(lay)
        lay.backgroundColor=UIColor.blackColor()
        lay.alpha=0.3
        
        lay2=UIView(frame: CGRectMake(0, self.view.bounds.height/7*6, self.view.bounds.width, self.view.bounds.height/7))
        lay2.backgroundColor=UIColor.whiteColor()
        self.sharelayout.addSubview(lay2)
        var weixin=UIButton(frame: CGRectMake(0, 0, self.view.bounds.height/7, self.view.bounds.height/7))
        weixin.setImage(UIImage(named: "weixin.png"), forState: UIControlState.Normal)
        weixin.addTarget(self, action: "wxfx", forControlEvents: UIControlEvents.TouchUpInside)
        lay2.addSubview(weixin)
        var pengyouquan=UIButton(frame: CGRectMake(self.view.bounds.height/7,0, self.view.bounds.height/7, self.view.bounds.height/7))
        pengyouquan.addTarget(self, action: "pyqfx", forControlEvents: UIControlEvents.TouchUpInside)
        pengyouquan.setImage(UIImage(named: "pengyouquan.png"), forState: UIControlState.Normal)
        lay2.addSubview(pengyouquan)
        
        let mapTranslate=JNWSpringAnimation(keyPath: "transform.translation.y")
        mapTranslate.damping=20
        mapTranslate.stiffness=5
        mapTranslate.mass=1
        mapTranslate.fromValue=self.view.bounds.height/7
        mapTranslate.toValue=0
        lay2.layer.addAnimation(mapTranslate, forKey: mapTranslate.keyPath)
        tapSingle=UITapGestureRecognizer(target: self, action: "tap")
        tapSingle.numberOfTapsRequired=1
        tapSingle.numberOfTouchesRequired=1
        self.sharelayout.addGestureRecognizer(tapSingle)
    }
    func tap(){
        let mapTranslate=JNWSpringAnimation(keyPath: "transform.translation.y")
        mapTranslate.damping=20
        mapTranslate.stiffness=5
        mapTranslate.mass=1
        mapTranslate.fromValue=0
        mapTranslate.toValue=self.view.bounds.height/7
        lay2.layer.addAnimation(mapTranslate, forKey: mapTranslate.keyPath)
        lay2.transform=CGAffineTransformTranslate(lay2.transform, 0,self.view.bounds.height)
        
        
        var  minseconds=0.6*Double(NSEC_PER_SEC)
        var dtime=dispatch_time(DISPATCH_TIME_NOW, Int64(minseconds))
        
        UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {()->Void in
            
            self.lay.alpha=0
            }, completion: nil)
        
        
        
        dispatch_after(dtime,dispatch_get_main_queue(),{
            self.sharelayout.removeFromSuperview()
        })
    }
    func crateplate(){
        platform=plate(view: self.view)
        platform.creatplate()
    }
    func loadAd(){
    _interstitialObj = GDTMobInterstitial(appkey: "1104208446", placementId: "5000104173338725")

    _interstitialObj.delegate = self //设置委托
    _interstitialObj.isGpsOn = false     //【可选】设置GPS开关
    _interstitialObj.loadAd()
    }
    func showAd(){
        var vc:UIViewController!=UIApplication.sharedApplication().keyWindow?.rootViewController
        var topVC = UIApplication.sharedApplication().keyWindow?.rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        vc=vc.presentedViewController!
        _interstitialObj.presentFromRootViewController(vc)
    }
    func interstitialSuccessToLoadAd(interstitial: GDTMobInterstitial!) {
        println("Success Loaded.")
        AdState=true

    }
    func interstitialFailToLoadAd(interstitial: GDTMobInterstitial!, errorCode: Int32) {
        println("Fail Loaded")
        AdState=false
        self.loadAd()

    }
    func changeMesgScene(secene:Int32){
        senceType = secene
    }
    func senderLinkContent(){
        
        var message = WXMediaMessage();
        message.title = "《PoleVault》"
        message.description = "PoleVault,获得30分的就算是高手了，我获得了\(self.sendscore)分"
        var ext = WXWebpageObject()
        ext.webpageUrl = self.downurl
        message.mediaObject = ext;
        
        
        var req = SendMessageToWXReq();
        req.bText = false;
        req.message = message;
        req.scene = senceType!;
        WXApi.sendReq(req);
        
        
    }
    
    func wxfx(){
        var isinstall = WXApi.isWXAppInstalled()
        if isinstall {
            
            
            
            delegate.changeMesgScene(0);
            
            
            delegate.senderLinkContent();
            
            
        }else{
            
            self.alertView?.show();
        }
    }
    func pyqfx(){
        var isinstall = WXApi.isWXAppInstalled()
        if isinstall {
            
            
            
            delegate.changeMesgScene(1);
            
            
            delegate.senderLinkContent();
            
            
        }else{
            
            self.alertView?.show();
        }
    }
    
    func createAlertView()->UIAlertView{
        if self.alertView == nil {
            self.alertView = UIAlertView(title: "温馨提示", message: "亲,你没有安装微信哦", delegate: nil, cancelButtonTitle: "确定");
            
        }
        return self.alertView!;
        
    }
    func loseplay(){
        var musicFilePath=NSBundle.mainBundle().pathForResource("lose", ofType: "mp3")
        var musicUrl=NSURL(fileURLWithPath: musicFilePath!)
        var audioPlayer=AVAudioPlayer(contentsOfURL: musicUrl, error: nil)
        self.losePlayer=audioPlayer
        losePlayer.prepareToPlay()
        losePlayer.numberOfLoops=0
        losePlayer.play()
    }
    ///////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
