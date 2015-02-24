//
//  ViewController.swift
//  PoleVault
//
//  Created by xlx on 15/2/1.
//  Copyright (c) 2015年 xlx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var downurl:String="https://itunes.apple.com/us/app/polevault/id964481943?mt=8&ign-mpt=uo%3D4"
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    @IBAction func grade(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: self.downurl)!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

