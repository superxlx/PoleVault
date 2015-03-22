//
//  GameScene.swift
//  PoleVault
//
//  Created by xlx on 15/3/6.
//  Copyright (c) 2015年 xlx. All rights reserved.
//

import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate{
    var PlayScene:playScene!
    override func didMoveToView(view: SKView) {
        PlayScene = playScene(size: self.size)
        self.view?.presentScene(PlayScene)
    }
}
