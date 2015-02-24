//
//  plate.swift
//  PoleVault
//
//  Created by xlx on 15/1/7.
//  Copyright (c) 2015年 xlx. All rights reserved.
//
import UIKit
class plate{
    var plate1:UIView!
    var plate2:UIView!
    var distance:UInt32!
    var width:UInt32!
    var view:UIView!
    var level=15
    init(view:UIView){
        self.view=view
        plate1=UIView(frame: CGRectMake(0, self.view.bounds.height/4*3, self.view.bounds.width/3, self.view.bounds.height/4))
        self.plate1.backgroundColor=UIColor.blackColor()
        self.view.addSubview(self.plate1)
    }
    func creatplate(){
        self.width=arc4random()%(UInt32)(self.view.bounds.width/3)+self.level
        self.distance=arc4random()%((UInt32)(self.view.bounds.width/3*2)-self.width-20)+20
        plate2=UIView(frame: CGRectMake(self.view.bounds.width/3+(CGFloat)(self.distance), self.view.bounds.height/4*3, (CGFloat)(self.width), self.view.bounds.height/4))
        self.plate2.backgroundColor=UIColor.blackColor()
        self.view.addSubview(self.plate2)
    }
    func compare(higher:CGFloat)->Bool{
        
        
        if higher>(CGFloat)(self.distance) && higher<(CGFloat)(self.distance+self.width) {
            return true
        }else{
            return false
        }
    }
    func re(level:Int){
        self.level=15-level/10
        if self.level<5{
            self.level=5
        }
        self.view.userInteractionEnabled=true
        self.plate2.removeFromSuperview()
        creatplate()
    }
    
}