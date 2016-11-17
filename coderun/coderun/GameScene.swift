//
//  GameScene.swift
//  coderun
//
//  Created by Kathryn Hodge on 11/2/16.
//  Copyright © 2016 blondiebytes. All rights reserved.
//

// TO DO:
// Add task - mini scene
// Add list of tasks
// Add pause button
// Welcome screen
// High score keeper

// - Set positions for circle (and make an obstacle)
// - create triangle http://sree.cc/iphone/how-to-draw-square-circle-and-triangle-using-xcode

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

  
    var player:SKSpriteNode!
    var initialPlayerPosition:CGPoint!
    
    var lastUpdateTimeInterval = TimeInterval()
    var lastYieldTimeInterval = TimeInterval()
    
    var rightPosLettering:CGFloat!
    var leftPosLettering:CGFloat!
    var middlePosLettering:CGFloat!
    
    var rightPosPlayer:CGFloat!
    var leftPosPlayer:CGFloat!
    var middlePosPlayer:CGFloat!
    
    var expression:SKLabelNode!
    var variable:String!
    var value:String!
    var obstacleColor:UIColor!
    
    var score:Int = 0
    var scoreLabel:SKLabelNode!
    
    enum direction:Int {
        case left = 0
        case right = 1
    }
    
    func resetPlayerPosition() {
        player.position = initialPlayerPosition
    }
    
    override func didMove(to view: SKView) {
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.respondToSwipeGestureRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.respondToSwipeGestureLeft(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
        self.view?.addGestureRecognizer(swipeLeft)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = UIColor.black
        addPlayer()
        
        addBoundary()
        addScore()
        
        rightPosLettering = self.size.width - player.size.width - 50
        leftPosLettering = player.size.width + 50
        middlePosLettering = self.size.width / 2
        
        rightPosPlayer = self.size.width - player.size.width - 150
        leftPosPlayer = player.size.width + 150
        middlePosPlayer = self.size.width / 2
        
        expression = SKLabelNode(fontNamed: "Chalkduster")
        expression.position = CGPoint(x: self.size.width / 2, y: self.size.height / 15)
        expression.text = "_____ = _____"
        expression.horizontalAlignmentMode = .center
        expression.fontSize = 60
        
        value = ""
        variable = ""
        
        obstacleColor = UIColor.white
        
        addChild(expression)
        
       // addRandomRow()
       // addRandomLetteringPosition(text: "bg.color = ")
        
    }

    
    func addRandomRow() {
        let randomNumber = Int(arc4random_uniform(9))
        
        switch randomNumber {
        case 0:
            addRow(type: RowType(rawValue: 0)!, pos: leftPosPlayer)
            break;
        case 1:
            addRow(type: RowType(rawValue: 1)!, pos: leftPosPlayer)
            break;
        case 2:
            addRow(type: RowType(rawValue: 2)!, pos: leftPosPlayer)
            break;
        case 3:
            addRow(type: RowType(rawValue: 0)!, pos: rightPosPlayer)
            break;
        case 4:
            addRow(type: RowType(rawValue: 1)!, pos: rightPosPlayer)
            break;
        case 5:
            addRow(type: RowType(rawValue: 2)!, pos: rightPosPlayer)
            break;
        case 6:
            addRow(type: RowType(rawValue: 0)!, pos: middlePosPlayer)
            break;
        case 7:
            addRow(type: RowType(rawValue: 1)!, pos: middlePosPlayer)
            break;
        case 8:
            addRow(type: RowType(rawValue: 2)!, pos: middlePosPlayer)
            break;
        default:
            break;
        }
    }
    
    func addRandomLetteringPosition(text:String) {
        let randomNumber = Int(arc4random_uniform(3))
        
        switch randomNumber {
        case 0:
            addLettering(text:text, pos: PositionType(rawValue: 0)!)
            break;
        case 1:
            addLettering(text:text, pos: PositionType(rawValue: 1)!)
            break;
        case 2:
            addLettering(text:text, pos: PositionType(rawValue: 2)!)
            break;
        default:
            break;
        }
    }
    
    func createLetters() -> String {
        let randomNumber = Int(arc4random_uniform(7))
        var s:String
        switch randomNumber {
        case 0:
            s = "p.color"
            break;
        case 1:
            s = "bg.color"
            break;
        case 2:
            s = "o.color"
            break;
        case 3:
            s = "red"
            break;
        case 4:
            s = "blue"
            break;
        case 5:
            s = "yellow"
            break;
        default:
            s = "green"
            break;
        }
        return s
    }
    
    var x:Double = 0;
    var y:Double = 500;
    var z:Double = 0;
    
    var level:Double = 2
    var levelLengths = [2.5, 4, 3]
    var timeLengths = [0.3, 0.5, 0.7, 1]
    var thisLevelLength:Double = 4
    var thisLetteringWaitLength:Double = 0.5
    
    var waitABitInBetweenSwitchingLevels:Bool = false
    var waiting = 0
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: TimeInterval) {
        lastYieldTimeInterval += timeSinceLastUpdate
        if lastYieldTimeInterval > level {
            lastYieldTimeInterval = 0
            if (waitABitInBetweenSwitchingLevels) {
                waiting = waiting + 1
                if (waiting > 1) {
                    waitABitInBetweenSwitchingLevels = false
                    x = 0
                    z = 0
                    waiting = 0
                }
            } else {
                addRandomRow()
                if (x > y * thisLetteringWaitLength) {
                    addRandomLetteringPosition(text:createLetters())
                    x = 0
                    let time:Int = Int(arc4random_uniform(3))
                    thisLetteringWaitLength = timeLengths[time]
                }
                if (z > y * thisLevelLength) {
                    if (level > 0.5) {
                        level = level - 0.25
                    }
                    z = 0
                    waitABitInBetweenSwitchingLevels = true
                    let len:Int = Int(arc4random_uniform(3))
                    thisLevelLength = levelLengths[len]
                }

            }
        }
        x = x + 1
        z = z + 1
    }
    
    var w:Int = 0
    
    override func update(_ currentTime: TimeInterval) {
        
        var timeSinceLastUpdate = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        if timeSinceLastUpdate > level {
            timeSinceLastUpdate = level
            lastUpdateTimeInterval = currentTime
        }
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate: timeSinceLastUpdate)
        if (w < 112 && switched) {
            if (w % 10 == 0 && w % 20 == 0) {
                expression.alpha = 1
            } else if (w % 10 == 0) {
                expression.alpha = 0
            } else if (w == 111) {
                expression.alpha = 1
                expression.text = "_____ = _____"
            }
            w += 1
        } else {
            w = 0
            switched = false
        }
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "BOUNDARY" && (contact.bodyB.node?.name?.contains("OBSTACLE"))! {
            if (contact.bodyB.node!.name == "OBSTACLE_LARGE") {
               score = score + 300
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.9, execute: {
                contact.bodyB.node?.removeFromParent()
                self.scoreLabel.text = String(self.score)
               })
            } else if (contact.bodyB.node!.name == "OBSTACLE_MEDIUM") {
                score = score + 200
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                    contact.bodyB.node?.removeFromParent()
                    self.scoreLabel.text = String(self.score)
                })
            } else {
                score = score + 100
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    contact.bodyB.node?.removeFromParent()
                    self.scoreLabel.text = String(self.score)
                })
            }
            
        }
        
        if contact.bodyA.node?.name == "PLAYER" && (contact.bodyB.node?.name?.contains("OBSTACLE"))! {
            print("GAME OVER")
            showGameOver()
        } else if (contact.bodyB.node?.name == "LETTERING"){
            print("LETTERING!!!")
            let node:SKLabelNode = contact.bodyB.node! as! SKLabelNode
            if (node.text?.contains("."))! {
                if (value != "") {
                    expression.text = node.text! + " = " + value
                    variable = node.text!
                    resetTraits()
                } else {
                    expression.text = node.text! + " = _____"
                    variable = node.text!
                }
            } else {
                if (variable != "") {
                    expression.text = variable + " = " + node.text!
                    value = node.text!
                    resetTraits()
                } else {
                    expression.text = "_____ = " + node.text!
                    value = node.text!
                }
                
            }
            
            contact.bodyB.node?.removeAllChildren()
            contact.bodyB.node?.removeFromParent()
        }
    }
    
    var switched = false
    
    func resetTraits() {
        setAttributes()
        score = score + 500
        scoreLabel.text = String(score)
        variable = ""
        value = ""
        switched = true
    }
    
    func setAttributes() {
        var val:UIColor = UIColor.white
        switch(value) {
            case "red": val = UIColor.red
            break;
            case "blue": val = UIColor.blue
            break;
            case "yellow": val = UIColor.yellow
            break;
            case "green": val = UIColor.green
            break;
        default:
            break;
        }
        switch(variable) {
            case "p.color": player.color = val
            break;
            case "o.color": obstacleColor = val
            break;
            case "bg.color": self.backgroundColor = val
        default:
            break;
        }
        
    }
    
    func showGameOver() {
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: size)
        self.view?.presentScene(gameOverScene, transition: transition)
    }
}
