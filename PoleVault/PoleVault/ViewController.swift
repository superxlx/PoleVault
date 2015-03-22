import UIKit
import AVFoundation
class ViewController: UIViewController ,GDTMobInterstitialDelegate{

    @IBOutlet weak var help: UIButton!
    @IBOutlet weak var value: UIButton!
    @IBOutlet weak var satrt: UIButton!
    var bgMusicPlayer = AVAudioPlayer()
    var AdState=false
    var adcount=0
    var viewbottom:UIView!
    var downurl:String="https://itunes.apple.com/us/app/polevault/id964481943?mt=8&ign-mpt=uo%3D4"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSUserDefaults.standardUserDefaults().setObject(self.adcount, forKey: "adcount")
        playBackGround()

   
    }
    @IBAction func grade(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: self.downurl)!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func help(sender: AnyObject) {
        viewbottom=UIView(frame: self.view.frame)
        self.view.addSubview(viewbottom)
        var layview=UIView(frame: self.view.frame)
        layview.backgroundColor=UIColor.grayColor()
        layview.alpha=0.8
        viewbottom.addSubview(layview)
        insertBlurView(layview,style: UIBlurEffectStyle.Dark)
        var border=UIImageView(frame: CGRectMake(0, 0, self.view.bounds.width-50, self.view.bounds.width-50))
        border.center=self.view.center
        border.image=UIImage(named: "边框.png")
        viewbottom.addSubview(border)
        var text=UITextView(frame: CGRectMake(0, 0, self.view.bounds.width-150, self.view.bounds.width-150))
        if self.view!.bounds.width>700 {
            text=UITextView(frame: CGRectMake(0, 0, self.view!.bounds.width-250, self.view!.bounds.width-250))
            text.font=UIFont(name: "Zapfino", size: 10)
        }
        text.text="在保护线以下，我们的斯派克翻山越岭：\n触摸保护线以下，替我们的斯派克搭建一座通过悬崖的木桥。木桥随触摸时间增长而增长，小心不要让我们的斯派克掉下悬崖了哦。\n大反派M&M博士，企图扔下M&M炸弹来炸毁保护线，如果保护线被炸毁，我们的斯派克将暴露在紫外线之下，而我们的任务就失败了。\n注意：\n只有红色的M&M炸弹才是真正的M&M炸弹，触摸M&M炸弹，提前引爆来保护我们的斯派克。\n我们在搭建木桥时，腾不出手来引爆炸弹。(木桥倾斜时无法触摸炸弹，虽然这个时间很短)\n触摸伪装的M&M炸弹将得到加分，其中：\n蓝色：不得分\n黄色：得1分\n绿色：得2分\n赶快加入战斗吧!"
        text.center=self.view.center
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
    func playBackGround(){
        //获取apple.mp3文件地址
        var bgMusicURL:NSURL =  NSBundle.mainBundle().URLForResource("backgroundsounds", withExtension: "mp3")!
        //根据背景音乐地址生成播放器
        bgMusicPlayer=AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
        //设置为循环播放
        bgMusicPlayer.numberOfLoops = -1
        //准备播放音乐
        bgMusicPlayer.prepareToPlay()
        //播放音乐
        bgMusicPlayer.play()
    }
}
