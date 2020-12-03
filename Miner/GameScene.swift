//
//  GameScene.swift
//  Miner
//
//  Created by Hollier, Alexander Phillip on 12/2/20.
//

import SpriteKit

var player = SKSpriteNode(imageNamed:"PlayerTEMP")
var up = SKSpriteNode(imageNamed:"up")
var left = SKSpriteNode(imageNamed:"left")
var down = SKSpriteNode(imageNamed:"down")
var right = SKSpriteNode(imageNamed:"right")

class GameScene: SKScene {

    
    override func didMove(to view: SKView) {
        
        spawnSprites()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            let touchedNode = atPoint(touchLocation)
            
            if touchedNode == up{
                player.position.y = player.position.y + 100
            }
            
            if touchedNode == down{
                player.position.y = player.position.y - 100
            }
            
            if touchedNode == left{
                player.position.x = player.position.x - 100
            }
            
            if touchedNode == right{
                player.position.x = player.position.x + 100
            }
        }
    }
    

    func spawnSprites(){
        player.position = CGPoint(x: frame.width / 2, y: frame.height - 200)
        down.position = CGPoint(x: 200, y: 200)
        up.position = CGPoint(x: 200, y: 300)
        left.position = CGPoint(x: 100, y: 200)
        right.position = CGPoint(x: 300, y: 200)
        
        self.addChild(player)
        self.addChild(down)
        self.addChild(up)
        self.addChild(left)
        self.addChild(right)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
