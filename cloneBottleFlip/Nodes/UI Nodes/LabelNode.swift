//
//  LabelNode.swift
//  cloneBottleFlip
//
//  Created by Egor Rybin on 15.04.2023.
//

import SpriteKit

class LabelNode: SKLabelNode {
    convenience init (text: String, fontSize: CGFloat, postion: CGPoint, fontColor: UIColor) {
        self.init(fontNamed: UI_FONT)
        self.text = text
        self.fontSize = fontSize
        self.position = postion
        self.fontColor = fontColor
    }
}
