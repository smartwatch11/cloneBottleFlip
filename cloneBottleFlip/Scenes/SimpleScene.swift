//
//  SimpleScene.swift
//  cloneBottleFlip
//
//  Created by Egor Rybin on 19.04.2023.
//

import SpriteKit

class SimpleScene: SKScene {

    func changeToSceneBy(nameScene: String, userData: NSMutableDictionary) {
        
        let scene = (nameScene == "GameScene") ? GameScene(size: self.size) : MenuScene(size: self.size)
        
        let transition = SKTransition.fade(with: UI_BACKGRAOUND_COLOR, duration: 0.3)
        
        scene.scaleMode = .aspectFill
        scene.userData = userData
        
        self.view?.presentScene(scene, transition: transition)
    }
    
    func playSoundFX(_ action: SKAction){
        self.run(action)
    }
}
