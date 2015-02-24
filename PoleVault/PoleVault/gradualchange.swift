import UIKit
    func gradualchange_alpha(time:NSTimeInterval,alp:CFloat,view:UIView){
        UIView.animateWithDuration(time, delay:0,options:UIViewAnimationOptions.CurveEaseInOut,animations:{()->Void in
            view.alpha=(CGFloat)(alp)
            },completion:nil)
    }
   func gradualchange_size(time:NSTimeInterval,width:CFloat,height:CGFloat,view:UIView){
    let jnw2=JNWSpringAnimation(keyPath: "transform.scale")
    jnw2.damping=10
    jnw2.stiffness=10
    jnw2.mass=1
    jnw2.fromValue=1
    jnw2.toValue=0
    view.layer.addAnimation(jnw2, forKey: jnw2.keyPath)
    view.transform=CGAffineTransformScale(CGAffineTransformIdentity, 0,0)
   }
   func gradualchange_rotation(speed:CGFloat,angle:Double,view:UIView){
    let rotation=JNWSpringAnimation(keyPath: "transform.rotation")
    rotation.damping=speed
    rotation.stiffness=0
    rotation.mass=2
    rotation.fromValue=0
    rotation.toValue=(angle/180)*M_PI
    view.layer.addAnimation(rotation, forKey: rotation.keyPath)
    view.transform=CGAffineTransformMakeRotation((CGFloat)(M_PI/2))
    
   }