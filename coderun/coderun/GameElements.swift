//
//  GameElements.swift
//  coderun
//
//  Created by Kathryn Hodge on 11/3/16.
//  Copyright © 2016 blondiebytes. All rights reserved.
//

import SpriteKit
import UIKit

struct CollisionBitMask {
    static let Player:UInt32 = 0x00
    static let Obstacle:UInt32 = 0x01
    static let Boundary:UInt32 = 0x10
}

enum ObstacleType:Int {
    case SmallRect = 0
    case MediumRect = 1
    case LargeRect = 2
}

enum RowType:Int {
    case oneS = 0
    case oneM = 1
    case oneL = 2
}

enum PositionType:Int {
    case left = 0
    case right = 1
    case middle = 2
}

extension GameScene {
    
    func addPlayer() {
        player = SKSpriteNode(color:UIColor.magenta, size: CGSize(width: 50, height: 50))
        player.position = CGPoint(x:self.size.width / 2, y: 350)
        player.name = "PLAYER"
        player.physicsBody?.isDynamic = false
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.categoryBitMask = CollisionBitMask.Player
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = CollisionBitMask.Obstacle
        
        addChild(player)
        
        initialPlayerPosition = player.position
        
    }
    
    func addObstacle(type:ObstacleType) ->SKSpriteNode {
        let obstacle = SKSpriteNode(color: obstacleColor, size: CGSize(width: 30, height: 0))
       
        obstacle.physicsBody?.isDynamic = true
        switch type {
        case .SmallRect:
            obstacle.size.height = self.size.height * 0.2
            obstacle.name = "OBSTACLE_SMALL"
            break
        case .MediumRect:
            obstacle.size.height = self.size.height * 0.35
            obstacle.name = "OBSTACLE_MEDIUM"
            break
        case .LargeRect:
            obstacle.size.height = self.size.height * 0.45
            obstacle.name = "OBSTACLE_LARGE"
            break
        }
        
        obstacle.position = CGPoint(x:0, y:self.size.height + obstacle.size.height)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        
        obstacle.physicsBody?.categoryBitMask = CollisionBitMask.Obstacle
        obstacle.physicsBody?.collisionBitMask = 0
        obstacle.physicsBody?.contactTestBitMask = CollisionBitMask.Boundary
        return obstacle
        
    }
    
    func addBoundary() {
        let boundary = SKSpriteNode(color: UIColor.red, size: CGSize(width: self.size.width * 2, height: 30))
        boundary.name = "BOUNDARY"
        boundary.physicsBody?.isDynamic = true
        boundary.position = CGPoint(x: 0, y: -30)
        boundary.physicsBody = SKPhysicsBody(rectangleOf: boundary.size)
        boundary.physicsBody?.categoryBitMask = CollisionBitMask.Boundary
        boundary.physicsBody?.collisionBitMask = 0

        addChild(boundary)
    }
    
    func addLettering(text:String, pos:PositionType) {
        let lettering = SKLabelNode(fontNamed: "Chalkduster")
        lettering.physicsBody?.isDynamic = true
        
        lettering.fontSize = 50
        lettering.name = "LETTERING"
        lettering.text = text
        lettering.horizontalAlignmentMode = .center
        
        switch pos {
        case .left:
            lettering.position = CGPoint(x: leftPosLettering, y: self.size.height + scoreLabel.fontSize * 2)
            lettering.horizontalAlignmentMode = .left
            break
        case .middle:
            lettering.position = CGPoint(x: middlePosLettering, y: self.size.height + scoreLabel.fontSize * 2)
            lettering.horizontalAlignmentMode = .center
            break
        case .right:
            lettering.position = CGPoint(x: rightPosLettering, y: self.size.height + scoreLabel.fontSize * 2)
            lettering.horizontalAlignmentMode = .right
            break
        }
        
        addMovement(lettering: lettering)
        lettering.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: lettering.fontSize * 7, height: lettering.fontSize / 2))
        
        lettering.physicsBody?.categoryBitMask = CollisionBitMask.Obstacle
        lettering.physicsBody?.collisionBitMask = 0
        
        addChild(lettering)
    }
    
    func addScore() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 50
        scoreLabel.name = "SCORE"
        scoreLabel.text = String(score)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: self.size.width / 8, y: self.size.height - scoreLabel.fontSize * 2)
        
        addChild(scoreLabel)
    }
    
    func addMovement(lettering:SKLabelNode) {
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: lettering.position.x, y: -lettering.fontSize * 2), duration: TimeInterval(7)))
        
        actionArray.append(SKAction.removeFromParent())
        
        lettering.run(SKAction.sequence(actionArray))
    }
    
    func addMovement(obstacle:SKSpriteNode) {
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: obstacle.position.x, y: -obstacle.size.height), duration: TimeInterval(3)))
        
        actionArray.append(SKAction.removeFromParent())
        
        obstacle.run(SKAction.sequence(actionArray))
        
    }
    
    func movePlayer(d: direction) {
        var xPos = player.position.x
        if (d == direction.right) {
            if (round(player.position.x) == middlePosPlayer) {
                xPos = leftPosPlayer
            } else if (round(player.position.x) == rightPosPlayer) {
                xPos = middlePosPlayer
            }
        } else {
            if (round(player.position.x) == middlePosPlayer) {
                xPos = rightPosPlayer
            } else if (round(player.position.x) == leftPosPlayer) {
                xPos = middlePosPlayer
            }
        }
        player.position = CGPoint(x:xPos, y: player.position.y)
    }
    
        
    
    func respondToSwipeGestureRight(_ gesture: UIGestureRecognizer) {
        movePlayer(d:direction.right)
    }
    
    func respondToSwipeGestureLeft(_ gesture: UIGestureRecognizer) {
        movePlayer(d:direction.left)
    }

    func addRow(type:RowType, pos:CGFloat) {
            switch type {
            case .oneS:
                let obst = addObstacle(type: .SmallRect)
                obst.position = CGPoint(x: pos, y: obst.position.y)
                addMovement(obstacle: obst)
                addChild(obst)
                break
            case .oneM:
                let obst = addObstacle(type: .MediumRect)
                obst.position = CGPoint(x: pos, y: obst.position.y)
                addMovement(obstacle: obst)
                addChild(obst)
                break
            case .oneL:
                let obst = addObstacle(type: .LargeRect)
                obst.position = CGPoint(x: pos, y: obst.position.y)
                addMovement(obstacle: obst)
                addChild(obst)
                break
        }

    }
        
    
    
   // func circle() {
       // let circlePath = UIBezierPath(arcCenter: CGPoint(x: 100,y: 100), radius: CGFloat(20), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
      //  let shapeLayer = CAShapeLayer()
      //  shapeLayer.path = circlePath.cgPath
        
        //change the fill color
      //  shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
     //   shapeLayer.strokeColor = UIColor.red.cgColor
        //you can change the line width
    //    shapeLayer.lineWidth = 3.0
     //   view?.layer.addSublayer(shapeLayer)
        
  //  }
    
    

    
    
}






















