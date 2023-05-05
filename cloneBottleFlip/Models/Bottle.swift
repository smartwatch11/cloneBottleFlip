//
//  Bottle.swift
//  cloneBottleFlip
//
//  Created by Egor Rybin on 18.04.2023.
//

import Foundation

class Bottle {
    var Sprite: String?
    var Mass: NSNumber?
    var Restitution: NSNumber?
    var XScale: NSNumber?
    var YScale: NSNumber?
    var MinFlips: NSNumber?
    
    init(_ bottleDictionary: NSDictionary){
        self.Sprite = bottleDictionary["Sprite"] as? String
        self.Mass = bottleDictionary["Mass"] as? NSNumber
        self.Restitution = bottleDictionary["Restitution"] as? NSNumber
        self.XScale = bottleDictionary["XScale"] as? NSNumber
        self.YScale = bottleDictionary["YScale"] as? NSNumber
        self.MinFlips = bottleDictionary["MinFlips"] as? NSNumber
    }
}
