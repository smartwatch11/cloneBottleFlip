//
//  BottleController.swift
//  cloneBottleFlip
//
//  Created by Egor Rybin on 18.04.2023.
//

import Foundation


class BottleController {
    class func readItems() -> [Bottle] {
        //Reading items from plist
        var bottles = [Bottle]()
        if let path = Bundle.main.path(forResource: "Items", ofType: "plist"), let plistArray = NSArray(contentsOfFile: path) as? [[String: Any]] {
            for dic in plistArray {
                let bottle = Bottle(dic as NSDictionary)
                bottles.append(bottle)
            }
        }
        return bottles
    }
    
    class func saveSelectedBottle(_ index: Int) {
        //save selected bottle
        UserDefaults.standard.set(index, forKey: "selectedBottle")
        UserDefaults.standard.synchronize()
    }
    
    class func getSaveBottleIndex() -> Int{
        //get saved index
        return UserDefaults.standard.integer(forKey: "selectedBottle")
    }
}
