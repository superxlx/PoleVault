import SpriteKit
protocol sendMessageDelegate : NSObjectProtocol{
    func changeMesgScene(secene:Int32);
    func senderLinkContent();
}
protocol reset{
    func rebuild()
}
class endScene:UIViewController,GDTMobInterstitialDelegate,sendMessageDelegate,WXApiDelegate{
    var score:Int!
    var selfsize:CGSize!
    var historyscore=0
    var viewbottom:UIView!
    var baseview:UIView!
    var adcount:Int!
    var downurl:String="https://itunes.apple.com/us/app/polevault/id964481943?mt=8&ign-mpt=uo%3D4"
    var AdState=false
    var _interstitialObj:GDTMobInterstitial!
    var sharelayout:UIView!
    var lay:UIView!
    var lay2:UIView!
    var senddelegate:sendMessageDelegate!
    var senceType: Int32?
    var alertView:UIAlertView?
    var gameCenter: GameCenter!
    var tapSingle:UITapGestureRecognizer!
    var resetdelegate:reset!
    var hislabel:UILabel!
    var scorelabel:UILabel!
    var test=0
    override func viewDidLoad() {
        self.gameCenter = GameCenter(rootViewController: self)
        /* Open Windows Game Center if player not login in Game Center */
        self.gameCenter.loginToGameCenter() {
            (result: Bool) in
            if result {
                println("login successful")
                /* Player is login in Game Center OR Open Windows for login in Game Center */
            } else {
                println("login fail")
                /* Player is not nogin in Game Center */
            }
        }
        onInit()
        self.view.backgroundColor=UIColor(red: 221/255, green: 230/255, blue: 213/255, alpha: 1)
        baseview=UIView(frame: self.view!.frame)
        self.view!.addSubview(baseview)
        senddelegate=self
        WXApi.registerApp("wxeac5c9dd2a8e9411")
        createAlertView()
        self.build()
    }
    override func viewDidAppear(animated: Bool) {
        println("viewdidappear")
        onInit()
        self.gameCenter.reportScore(score: self.score, leaderboardIdentifier: "20150312", completion: { (result) -> Void in
            if result {
                println("report score successful")
                /* Result is submit */
            } else {
                println("report score fail")
                /* Is fail */
            }
        })
        if self.score > self.historyscore {
            self.historyscore=self.score
            NSUserDefaults.standardUserDefaults().setObject(self.historyscore, forKey: "historyscore")
      
        }
        hislabel.text="\(self.historyscore)"
        scorelabel.text="\(self.score)"
        
        var a: AnyObject! = NSUserDefaults.standardUserDefaults().valueForKey("adcount")
        self.adcount=a! as Int
        
        if self._interstitialObj != nil {
            println(self.adcount)
            if self.adcount>=3{
                showad()
            }else{
                println("not time to showad")
            }
        }else{
            println("ad is not ready")
        }
        self.adcount=self.adcount+1
        NSUserDefaults.standardUserDefaults().setObject(self.adcount, forKey: "adcount")
 
    }
    func onInit(){
        if let b: AnyObject = NSUserDefaults.standardUserDefaults().valueForKey("score"){
            self.score=b as Int
        }
        if let a: AnyObject = NSUserDefaults.standardUserDefaults().valueForKey("historyscore"){
            self.historyscore=a as Int
        }
    }
    func build(){
        var scoreimage=UIImageView(frame: CGRectMake(0, self.view!.bounds.height/2-self.view!.bounds.width/3*2, self.view!.bounds.width, self.view!.bounds.width/3*2))
           if self.score>self.historyscore{
            self.historyscore=self.score
            NSUserDefaults.standardUserDefaults().setObject(self.historyscore, forKey: "historyscore")
            scoreimage.image=UIImage(named: "newrecord.png")
        }else{
            scoreimage.image=UIImage(named: "gameover.png")
        }
        self.baseview.addSubview(scoreimage)
        var hisscorebottom=UIView(frame: CGRectMake(self.view!.bounds.width/4, self.view!.bounds.height/2, self.view!.bounds.width/2,self.view!.bounds.width/10))
        self.baseview.addSubview(hisscorebottom)
        var hisimage=UIImageView(frame: CGRectMake(0, 0, self.view!.bounds.width/4, self.view!.bounds.width/10))
        hisimage.image=UIImage(named: "historyscore.png")
        hisscorebottom.addSubview(hisimage)
        hislabel=UILabel(frame: CGRectMake(self.view!.bounds.width/4, 0, self.view!.bounds.width/4, self.view!.bounds.width/10))
       
        hisscorebottom.addSubview(hislabel)
        
        var scorebottom=UIView(frame: CGRectMake(self.view!.bounds.width/4, self.view!.bounds.height/20*11+10, self.view!.bounds.width/2, self.view!.bounds.width/10))
        self.baseview.addSubview(scorebottom)
        var endscoreimage=UIImageView(frame: CGRectMake(0, 0, self.view!.bounds.width/4, self.view!.bounds.width/10))
        endscoreimage.image=UIImage(named: "endscore.png")
        scorebottom.addSubview(endscoreimage)
        scorelabel=UILabel(frame: CGRectMake(self.view!.bounds.width/4, 0, self.view!.bounds.width/4, self.view!.bounds.width/10))
        
        scorebottom.addSubview(scorelabel)
        
        var start=UIButton(frame: CGRectMake(self.view!.bounds.width/2-110, self.view!.bounds.height/10*7, 100, 30))
        var value=UIButton(frame: CGRectMake(self.view!.bounds.width/2+10, self.view!.bounds.height/10*7, 100, 30))
        var share=UIButton(frame: CGRectMake(self.view!.bounds.width/2-110, self.view!.bounds.height/10*7+40, 100, 30))
        var help=UIButton(frame:  CGRectMake(self.view!.bounds.width/2+10, self.view!.bounds.height/10*7+40, 100, 30))
        var lead=UIButton(frame:  CGRectMake(self.view!.bounds.width/2-110, self.view!.bounds.height/10*7+80, 100, 30))
        start.setImage(UIImage(named: "开始.png"), forState: UIControlState.Normal)
        value.setImage(UIImage(named: "评分.png"), forState: UIControlState.Normal)
        share.setImage(UIImage(named: "分享.png"), forState: UIControlState.Normal)
        help.setImage(UIImage(named: "help.png"), forState: UIControlState.Normal)
        lead.setImage(UIImage(named: "lead.png"), forState: UIControlState.Normal)
        
        start.addTarget(self, action: "start", forControlEvents: UIControlEvents.TouchUpInside)
        value.addTarget(self, action: "value", forControlEvents: UIControlEvents.TouchUpInside)
        share.addTarget(self, action: "share", forControlEvents: UIControlEvents.TouchUpInside)
        help.addTarget( self, action: "help",  forControlEvents: UIControlEvents.TouchUpInside)
        lead.addTarget(self, action: "showlead", forControlEvents: UIControlEvents.TouchUpInside)
        self.baseview.addSubview(start)
        self.baseview.addSubview(value)
        self.baseview.addSubview(share)
        self.baseview.addSubview(help)
        self.baseview.addSubview(lead)
        
    }
    func showlead(){
        gameCenter.showGameCenterLeaderboard(leaderboardIdentifier: "20150312") { (result) -> Void in
            if result {
                println("show leaderboard successful")
                /* Game Center Window is open */
            } else {
                println("show leaderboard fail")
                self.gameCenter.loginToGameCenter() {
                    (result: Bool) in
                    if result {
                        println("login successful")
                        /* Player is Login in Game Center OR Open Windows for login in Game Center */
                    } else {
                        println("login fail")
                        /* Player is Not Login in Game Center */
                    }
                }
                /* Game Center Window is not open (Example player not login in Game Center) */
            }
        }
    }
    func start(){
        self.resetdelegate.rebuild()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func value(){
        UIApplication.sharedApplication().openURL(NSURL(string: self.downurl)!)
    }
    func share(){
        self.sharelayout=UIView(frame: self.view!.frame)
        self.view!.addSubview(sharelayout)
        sharelayout.backgroundColor=nil
        lay=UIView(frame: self.view!.frame)
        self.sharelayout.addSubview(lay)
        lay.backgroundColor=UIColor.blackColor()
        lay.alpha=0.1
        
        lay2=UIView(frame: CGRectMake(0, self.view!.bounds.height/7*6, self.view!.bounds.width, self.view!.bounds.height/7))
        lay2.backgroundColor=UIColor.whiteColor()
        self.sharelayout.addSubview(lay2)
        var weixin=UIButton(frame: CGRectMake(0, 0, self.view!.bounds.height/7, self.view!.bounds.height/7))
        weixin.setImage(UIImage(named: "weixin.png"), forState: UIControlState.Normal)
        weixin.addTarget(self, action: "wxfx", forControlEvents: UIControlEvents.TouchUpInside)
        lay2.addSubview(weixin)
        var pengyouquan=UIButton(frame: CGRectMake(self.view!.bounds.height/7,0, self.view!.bounds.height/7, self.view!.bounds.height/7))
        pengyouquan.addTarget(self, action: "pyqfx", forControlEvents: UIControlEvents.TouchUpInside)
        pengyouquan.setImage(UIImage(named: "pengyouquan.png"), forState: UIControlState.Normal)
        lay2.addSubview(pengyouquan)
        
        let mapTranslate=JNWSpringAnimation(keyPath: "transform.translation.y")
        mapTranslate.damping=20
        mapTranslate.stiffness=5
        mapTranslate.mass=1
        mapTranslate.fromValue=self.view!.bounds.height/7
        mapTranslate.toValue=0
        lay2.layer.addAnimation(mapTranslate, forKey: mapTranslate.keyPath)
        insertBlurView(sharelayout,style: UIBlurEffectStyle.Dark)
        tapSingle=UITapGestureRecognizer(target: self, action: "tap")
        tapSingle.numberOfTapsRequired=1
        tapSingle.numberOfTouchesRequired=1
        self.sharelayout.addGestureRecognizer(tapSingle)
    }
    func help(){
        viewbottom=UIView(frame: self.view!.frame)
        self.view!.addSubview(viewbottom)
        var layview=UIView(frame: self.view!.frame)
        layview.backgroundColor=UIColor.grayColor()
        layview.alpha=0.8
        viewbottom.addSubview(layview)
        insertBlurView(layview,style: UIBlurEffectStyle.Dark)
        var border=UIImageView(frame: CGRectMake(0, 0, self.view!.bounds.width-50, self.view!.bounds.width-50))
        border.center=self.view!.center
        border.image=UIImage(named: "边框.png")
        viewbottom.addSubview(border)
        var text=UITextView(frame: CGRectMake(0, 0, self.view!.bounds.width-150, self.view!.bounds.width-150))

        if self.view!.bounds.width>700 {
            text=UITextView(frame: CGRectMake(0, 0, self.view!.bounds.width-250, self.view!.bounds.width-250))
            text.font=UIFont(name: "Zapfino", size: 10)
        }
        text.text="在保护线以下，我们的斯派克翻山越岭：\n触摸保护线以下，替我们的斯派克搭建一座通过悬崖的木桥。木桥随触摸时间增长而增长，小心不要让我们的斯派克掉下悬崖了哦。\n大反派M&M博士，企图扔下M&M炸弹来炸毁保护线，如果保护线被炸毁，我们的斯派克将暴露在紫外线之下，而我们的任务就失败了。\n注意：\n只有红色的M&M炸弹才是真正的M&M炸弹，触摸M&M炸弹，提前引爆来保护我们的斯派克。\n我们在搭建木桥时，腾不出手来引爆炸弹。(木桥倾斜时无法触摸炸弹，虽然这个时间很短)\n触摸伪装的M&M炸弹将得到加分，其中：\n蓝色：不得分\n黄色：得1分\n绿色：得2分\n赶快加入战斗吧!"
        text.center=self.view!.center
        text.editable=false
        text.textColor=UIColor.whiteColor()
        text.backgroundColor=nil
        viewbottom.addSubview(text)
        var back=UIButton(frame: CGRectMake(10, 50, 50, 50))
        back.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        back.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        viewbottom.addSubview(back)
        viewbottom.alpha=0
        gradualchange_alpha(1, 1, viewbottom)
    }
    func back(){
        gradualchange_alpha(1, 0, viewbottom)
    }
    func insertBlurView (view: UIView,  style: UIBlurEffectStyle) {
        view.backgroundColor = UIColor.clearColor()
        var blurEffect = UIBlurEffect(style: style)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.insertSubview(blurEffectView, atIndex: 0)
    }
    func showad(){
        _interstitialObj.delegate=self
        _interstitialObj.presentFromRootViewController(self)
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
    
    func changeMesgScene(secene:Int32){
        senceType = secene
    }
    func senderLinkContent(){
        var message = WXMediaMessage();
        message.title = "《PoleVault》"
        message.description = "PoleVault,听说获得100分以上，联系开发者将有神秘大奖，我获得了\(self.score)分"
        var ext = WXWebpageObject()
        ext.webpageUrl = self.downurl
        message.mediaObject = ext;
        var req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = senceType!
        WXApi.sendReq(req)
    }
    
    func wxfx(){
        var isinstall = WXApi.isWXAppInstalled()
        if isinstall {
            senddelegate.changeMesgScene(0)
            senddelegate.senderLinkContent()
        }else{
            
            self.alertView?.show();
        }
    }
    func pyqfx(){
        var isinstall = WXApi.isWXAppInstalled()
        if isinstall {
            senddelegate.changeMesgScene(1);
            senddelegate.senderLinkContent();
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
    func interstitialDidDismissScreen(interstitial: GDTMobInterstitial!) {
        println("回调成功")
        self.adcount = 0
        NSUserDefaults.standardUserDefaults().setObject(self.adcount, forKey: "adcount")
    }
}