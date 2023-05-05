//
//  MenuScene.swift
//  cloneBottleFlip
//
//  Created by Egor Rybin on 11.04.2023.
//

import SpriteKit

class MenuScene: SimpleScene {
    
    var playButtonNode = SKSpriteNode()
    var tableNode = SKSpriteNode()
    var bottleNode = SKSpriteNode()
    var leftButtonNode = SKSpriteNode()
    var rightButtonNode = SKSpriteNode()
    var flipsTagNote = SKSpriteNode()
    var unclockLabelNode = SKLabelNode()
    
    var highScore = 0
    var totalFlips = 0
    var bottles = [Bottle]()
    var selectedBottleIndex = 0
    var totalBottles = 0
    var isShopButton = false
    
    var popSound = SKAction()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UI_BACKGRAOUND_COLOR
        bottles = BottleController.readItems()
        //print(bottle)
        totalBottles = bottles.count
        
        // get total flip
        highScore = UserDefaults.standard.integer(forKey: "localHighScore")
        totalFlips = UserDefaults.standard.integer(forKey: "flips")
        
        popSound = SKAction.playSoundFileNamed(GAME_SOUND_POP, waitForCompletion: false)
        
        setupUI()
    }
    
    func setupUI(){
        //logo node
        let logo = buttonNode(imageNode: "logo", position: CGPoint(x: self.frame.midX, y: self.frame.maxY - 75), xScale: 1, yScale: 1)
        self.addChild(logo)
        
        // best score
        let bestScoreLabelNode = LabelNode(text: "Лучший результат", fontSize: 15.0, postion: CGPoint(x: self.frame.midX - 100, y: self.frame.maxY - 150), fontColor: UIColor(red: 193/255, green: 88/255, blue: 88/255, alpha: 1.0))
        
        self.addChild(bestScoreLabelNode)
        
        //high score label
        let highScoreLabelNode = LabelNode(text: String(highScore), fontSize: 70.0, postion: CGPoint(x: self.frame.midX - 100, y: self.frame.maxY - 230), fontColor: UIColor(red: 193/255, green: 88/255, blue: 88/255, alpha: 1.0))
        self.addChild(highScoreLabelNode)
        
        //Total flips label
        let totalFlipsLabelNode = LabelNode(text: "Кол-во сальт", fontSize: 15.0, postion: CGPoint(x: self.frame.midX + 100, y: self.frame.maxY - 150), fontColor: UIColor(red: 36/255, green: 59/255, blue: 170/255, alpha: 1.0))
        self.addChild(totalFlipsLabelNode)
        
        //Total Flips score label
        let FlipsLabelNode = LabelNode(text: String(totalFlips), fontSize: 70.0, postion: CGPoint(x: self.frame.midX + 100, y: self.frame.maxY - 230), fontColor: UIColor(red: 36/255, green: 59/255, blue: 170/255, alpha: 1.0))
        self.addChild(FlipsLabelNode)
        
        //play button
        playButtonNode = buttonNode(imageNode: "play_button", position: CGPoint(x: self.frame.midX, y: self.frame.midY - 15), xScale: 0.9, yScale: 0.9)
        self.addChild(playButtonNode)
        
        //table node
        tableNode = buttonNode(imageNode: "table", position: CGPoint(x: self.frame.midX, y: self.frame.minY + 29), xScale: 0.45, yScale: 0.45)
        tableNode.zPosition = 3
        self.addChild(tableNode)
        
        //bottle node
        selectedBottleIndex = BottleController.getSaveBottleIndex()
        let selectedBottle = bottles[selectedBottleIndex]
        
        bottleNode = SKSpriteNode(imageNamed: selectedBottle.Sprite!)
        bottleNode.zPosition = 10
        self.addChild(bottleNode)
        
        
        //left button
        leftButtonNode = buttonNode(imageNode: "left_button", position: CGPoint(x: self.frame.midX + leftButtonNode.size.width - 130, y: self.frame.minY - leftButtonNode.size.height + 145), xScale: 0.8, yScale: 0.8)
        self.changeButton(leftButtonNode, state: false)
        self.addChild(leftButtonNode)
        
        //right button
        rightButtonNode = buttonNode(imageNode: "right_button", position: CGPoint(x: self.frame.midX + rightButtonNode.size.width + 130, y: self.frame.minY - rightButtonNode.size.height + 145), xScale: 0.8, yScale: 0.8)
        self.changeButton(rightButtonNode, state: true)
        self.addChild(rightButtonNode)
        
        //lock node
        flipsTagNote = buttonNode(imageNode: "lock", position: CGPoint(x: self.frame.midX + bottleNode.size.width * 0.25, y: self.frame.minY + bottleNode.size.height/2 + 94), xScale: 0.5, yScale: 0.5)
        flipsTagNote.zPosition = 25
        flipsTagNote.zRotation = 0.3
        self.addChild(flipsTagNote)
        
        // unlock label
        unclockLabelNode = LabelNode(text: "0", fontSize: 36, postion: CGPoint(x: 0, y: -unclockLabelNode.frame.size.height + 25), fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        unclockLabelNode.zPosition = 30
        //unclockLabelNode.zRotation = 0.3
        flipsTagNote.addChild(unclockLabelNode)
        
        // update selected bottle
        self.updateSelectedBottle(selectedBottle)
        
        
        self.pulseLockNode(flipsTagNote)
    }
    
    func changeButton(_ buttonNode: SKSpriteNode, state: Bool) {
        //Change arrow sprites
        var buttonColor = #colorLiteral(red: 0.4157889783, green: 0.4311676025, blue: 0.5182750225, alpha: 0.2098509934)
        //UIColor(red: 87/255, green: 90/255, blue: 113/255, alpha: 1.0)
        
        if state {
            buttonColor = #colorLiteral(red: 0.4157889783, green: 0.4311676025, blue: 0.5182750225, alpha: 1)
        }
        
        buttonNode.color = buttonColor
        buttonNode.colorBlendFactor = 1
    }
    
    func updateSelectedBottle(_ bottle: Bottle) {
        
        // update to the sselected bottle
        let unlockFlips = bottle.MinFlips!.intValue - highScore
        let unlocked = (unlockFlips <= 0)
        
        flipsTagNote.isHidden = unlocked
        unclockLabelNode.isHidden = unlocked
        
        bottleNode.texture = SKTexture(imageNamed: bottle.Sprite!)
        playButtonNode.texture = SKTexture(imageNamed: (unlocked ? "play_button" : "shop_button"))
        
        isShopButton = !unlocked
        
        bottleNode.size = CGSize(width: bottleNode.texture!.size().width * CGFloat(bottle.XScale!.floatValue), height: bottleNode.texture!.size().height * CGFloat(bottle.YScale!.floatValue))
        
        bottleNode.position = CGPoint(x: self.frame.midX, y: self.frame.minY + bottleNode.size.height/2 + 94)
        
        flipsTagNote.position = CGPoint(x: self.frame.midX + bottleNode.size.width * 0.25, y: self.frame.minY + bottleNode.size.height/2 + 94)
        
        unclockLabelNode.text = "\(bottle.MinFlips!.intValue)"
        unclockLabelNode.position = CGPoint(x: 0, y: -unclockLabelNode.frame.size.height + 25)
        
        self.updateArrowsState()
    }
    
    func updateArrowsState() {
        // update arrows state
        self.changeButton(leftButtonNode, state: Bool(truncating: selectedBottleIndex as NSNumber))
        self.changeButton(rightButtonNode, state: selectedBottleIndex != totalBottles - 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
  
        for touch in touches {
            let location = touch.location(in: self)
            
            // play button is rest
            if playButtonNode.contains(location) {
                self.playSoundFX(popSound)
                self.startGame()
            }
            
            if leftButtonNode.contains(location) {
                let prevIndex = selectedBottleIndex - 1
                if prevIndex >= 0 {
                    self.playSoundFX(popSound)
                    self.updateByIndex(prevIndex)
                }
            }
            
            if rightButtonNode.contains(location) {
                let nextIndex = selectedBottleIndex + 1
                if nextIndex < totalBottles {
                    self.playSoundFX(popSound)
                    self.updateByIndex(nextIndex)
                }
            }
        }
    }
    
    func updateByIndex(_ index: Int){
        let bottle = bottles[index]
        selectedBottleIndex = index
        self.updateSelectedBottle(bottle)
        BottleController.saveSelectedBottle(selectedBottleIndex)
    }
    
    func pulseLockNode(_ node: SKSpriteNode) {
        //pulse animation on lock
        let scaleDownAction = SKAction.scale(to: 0.35, duration: 0.5)
        let scaleUpAction = SKAction.scale(to: 0.5, duration: 0.5)
        let seq = SKAction.sequence([scaleDownAction, scaleUpAction])
        
        node.run(SKAction.repeatForever(seq))
    }
    
    func startGame() {
        // not shop button, so start game
        if !isShopButton {
            let userData: NSMutableDictionary
            userData = ["bottle": bottles[selectedBottleIndex]]
            self.changeToSceneBy(nameScene: "GameScene", userData: userData)
        } else {
            // start in-app purchase
            print("start iAP")
        }
    }
}
