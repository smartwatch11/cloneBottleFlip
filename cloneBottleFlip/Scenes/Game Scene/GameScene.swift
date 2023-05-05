//
//  GameScene.swift
//  cloneBottleFlip
//
//  Created by Egor Rybin on 11.04.2023.
//
//import UIKit
import SpriteKit


class GameScene: SimpleScene {

    var scoreLabelNode = SKLabelNode()
    var highscoreLabelNode = SKLabelNode()
    var backButtonNode = SKSpriteNode()
    var resetButtonNode = SKSpriteNode()
    var tutorialNode = SKSpriteNode()
    var bottleNode = SKSpriteNode()
    var didSwipe = false
    var start = CGPoint.zero
    var startTime = TimeInterval()
    var currentScore = 0
    
    var popSound = SKAction()
    var failSound = SKAction()
    var winSound = SKAction()
    
    override func didMove(to view: SKView) {
        //setting the scene
        self.physicsBody?.restitution = 0
        self.backgroundColor = UI_BACKGRAOUND_COLOR
        
        self.setupUINodes()
        self.setupGameNodes()
        
        popSound = SKAction.playSoundFileNamed(GAME_SOUND_POP, waitForCompletion: false)
        failSound = SKAction.playSoundFileNamed(GAME_SOUND_FAIL, waitForCompletion: false)
        winSound = SKAction.playSoundFileNamed(GAME_SOUND_WIN, waitForCompletion: false)
    }

    func setupUINodes() {
        // score label node
        scoreLabelNode = LabelNode(text: "0", fontSize: 140, postion: CGPoint(x: self.frame.midX, y: self.frame.midY), fontColor: UIColor(red: 144/255, green: 149/255, blue: 219/255, alpha: 0.6))
        scoreLabelNode.zPosition = 1
        self.addChild(scoreLabelNode)
        
        // highscore label node
        highscoreLabelNode = LabelNode(text: "New result", fontSize: 32, postion: CGPoint(x: self.frame.midX, y: self.frame.midX - 40), fontColor: UIColor(red: 144/255, green: 149/255, blue: 219/255, alpha: 0.6))
        highscoreLabelNode.zPosition = -1
        highscoreLabelNode.isHidden = true
        self.addChild(highscoreLabelNode)
        
        //back button
        backButtonNode = buttonNode(imageNode: "back_button", position: CGPoint(x: self.frame.minX + backButtonNode.size.width + 30, y: self.frame.maxY - backButtonNode.size.height - 40), xScale: 0.65, yScale: 0.65)
        self.addChild(backButtonNode)
        
        //reset button
        resetButtonNode = buttonNode(imageNode: "reset_button", position: CGPoint(x: self.frame.maxX - resetButtonNode.size.width - 40, y: self.frame.maxY - resetButtonNode.size.height - 40), xScale: 0.65, yScale: 0.65)
        self.addChild(resetButtonNode)
        
        //tutorial button
        let tutorialFinished = UserDefaults.standard.bool(forKey: "tutorialFinished")
        tutorialNode = buttonNode(imageNode: "tutorial", position: CGPoint(x: self.frame.midX, y: self.frame.midY), xScale: 0.55, yScale: 0.55)
        tutorialNode.zPosition = 5
        tutorialNode.isHidden = tutorialFinished
        self.addChild(tutorialNode)
        
    }
    
    func setupGameNodes() {
        // table node
        let tableNode = SKSpriteNode(imageNamed: "table")
        tableNode.physicsBody = SKPhysicsBody(rectangleOf: (tableNode.texture?.size())!)
        tableNode.physicsBody?.affectedByGravity = false
        tableNode.physicsBody?.isDynamic = false
        tableNode.physicsBody?.restitution = 0
        tableNode.xScale = 0.45
        tableNode.yScale = 0.45
        tableNode.position = CGPoint(x: self.frame.midX, y: 29)
        self.addChild(tableNode)
        
        //bottle node
        let selectedBottle = self.userData?.object(forKey: "bottle")
        bottleNode = BottleNode(selectedBottle as! Bottle)!
        self.addChild(bottleNode)
        
        self.resetBottle()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //start recording touches
        if touches.count > 1 {
            return
        }
        
        let touch = touches.first
        let location = touch!.location(in: self)
        
        start = location
        startTime = touch!.timestamp
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if backButtonNode.contains(location) {
                self.playSoundFX(popSound)
                self.changeToSceneBy(nameScene: "MenuScene", userData: NSMutableDictionary.init())
            }
            
            if resetButtonNode.contains(location) && (didSwipe == true) {
                //fix it sound
                // test
                self.playSoundFX(popSound)
                failedFlip()
            }
            
            if tutorialNode.contains(location) {
                tutorialNode.isHidden = true
                UserDefaults.standard.set(true, forKey: "tutorialFinished")
                UserDefaults.standard.synchronize()
            }
        }
        
        //bottle flipping logic
        if !didSwipe {
            
            let touch = touches.first
            let location = touch?.location(in: self)
            
            let x = ceil(location!.x - start.x)
            let y = ceil(location!.y - start.y)
            
            let distance = sqrt(x*x+y*y)
            let time = CGFloat(touch!.timestamp - startTime)
            
            if (distance >= GAME_SWIPE_MIN_DISTANCE && y > 0) {
                let speed = distance/time
                
                if speed >= GAME_SWIPE_MIN_SPEED {
                    bottleNode.physicsBody?.angularVelocity = GAME_ANGULAR_VELOCITY
                    bottleNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: distance * GAME_DISTANCE_MULTIPLIER))
                    didSwipe = true
                }
            }
        }
    }
    
    func failedFlip() {
        // failed flipp reset score bottle
        self.playSoundFX(failSound)
        currentScore = 0
        
        self.updateScore()
        self.resetBottle()
    }
    
    func resetBottle() {
        // reset bottle after failed
        self.playSoundFX(popSound)
        bottleNode.position = CGPoint(x: self.frame.midX, y: bottleNode.size.height)
        bottleNode.physicsBody?.angularDamping = 0
        bottleNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bottleNode.speed = 0
        bottleNode.zRotation = 0
        didSwipe = false
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        self.checkIfSuccessFullFlip()
    }
    
    func checkIfSuccessFullFlip(){
        if (bottleNode.position.x <= 0 || bottleNode.position.x >= self.frame.size.width || bottleNode.position.y <= 0) {
            self.failedFlip()
        }
        
        if (didSwipe && bottleNode.physicsBody!.isResting) {
            let bottleRotation = abs(Float(bottleNode.zRotation))
            
            if (bottleRotation > 0 && bottleRotation < 0.05) {
                self.successFlip()
            } else {
                self.failedFlip()
            }
        }
    }
    
    func successFlip() {
        // successfully fliped, update score
        self.playSoundFX(winSound)
        self.updateFlips()
        
        currentScore += 1
        
        self.updateScore()
        self.resetBottle()
    }
    
    func updateScore() {
        // updating score based on flips and save highest
        
        scoreLabelNode.text = "\(currentScore)"
        
        let localHighScore = UserDefaults.standard.integer(forKey: "localHighScore")
        
        if currentScore > localHighScore {
            highscoreLabelNode.isHidden = false
            
            let fadeAction = SKAction.fadeAlpha(to: 0, duration: 1.0)
            highscoreLabelNode.run(fadeAction, completion: {
                self.highscoreLabelNode.isHidden = true
            })
            
            UserDefaults.standard.set(currentScore, forKey: "localHighScore")
            UserDefaults.standard.synchronize()
        }
    }
    
    func updateFlips() {
        // update total flips
        var flips = UserDefaults.standard.integer(forKey: "flips")
        
        flips += 1
        UserDefaults.standard.set(flips, forKey: "flips")
        UserDefaults.standard.synchronize()
        
    }
}
