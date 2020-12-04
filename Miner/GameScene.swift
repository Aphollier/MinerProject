//
//  GameScene.swift
//  Miner
//
//  Created by Hollier, Alexander Phillip on 12/2/20.
//

import SpriteKit


var up = SKSpriteNode(imageNamed:"up")
var left = SKSpriteNode(imageNamed:"left")
var down = SKSpriteNode(imageNamed:"down")
var right = SKSpriteNode(imageNamed:"right")
var player = SKSpriteNode(imageNamed:"miner")
var underground = [[SKSpriteNode]]()

class GameScene: SKScene {

    
    override func didMove(to view: SKView) {
        
        spawnSprites()
        generateEarth()
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
    
    func generateEarth(){
        var undergroundRow = [SKSpriteNode]()
        
        for m in 0...9{
            for n in 0...8{
                let currentBlock = SKSpriteNode(imageNamed: "dirt")
                currentBlock.size = CGSize(width: 100, height: 100)
                currentBlock.position = CGPoint(x: 0 + 100*n, y: 100 + 100*m)
                currentBlock.zPosition = 0
                self.addChild(currentBlock)
            
                undergroundRow.append(currentBlock)
            }
            underground.append(undergroundRow)
        }
    }

    func spawnSprites(){
        player.position = CGPoint(x: 300, y: 1100)
        player.zPosition = 1
        down.position = CGPoint(x: 200, y: 200)
        down.zPosition = 2
        up.position = CGPoint(x: 200, y: 300)
        up.zPosition = 2
        left.position = CGPoint(x: 100, y: 200)
        left.zPosition = 2
        right.position = CGPoint(x: 300, y: 200)
        right.zPosition = 2
        
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
