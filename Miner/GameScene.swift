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
                let deleteNode = atPoint(CGPoint(x: player.position.x, y: player.position.y + 100))
                if deleteNode.name == "ground"{
                    deleteNode.removeFromParent()
                }
                player.position.y = player.position.y + 100
            }
            
            if touchedNode == down{
                let deleteNode = atPoint(CGPoint(x: player.position.x, y: player.position.y - 100))
                if deleteNode.name == "ground"{
                    deleteNode.removeFromParent()
                }
                
                player.position.y = player.position.y - 100
            }
            
            if touchedNode == left{
                let deleteNode = atPoint(CGPoint(x: player.position.x - 100, y: player.position.y))
                if deleteNode.name == "ground"{
                    deleteNode.removeFromParent()
                }
                
                player.position.x = player.position.x - 100
            }
            
            if touchedNode == right{
                let deleteNode = atPoint(CGPoint(x: player.position.x + 100, y: player.position.y))
                if deleteNode.name == "ground"{
                    deleteNode.removeFromParent()
                }
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
                currentBlock.name = "ground"
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
        down.alpha = 0.5
        up.position = CGPoint(x: 200, y: 300)
        up.zPosition = 2
        up.alpha = 0.5
        left.position = CGPoint(x: 100, y: 200)
        left.zPosition = 2
        left.alpha = 0.5
        right.position = CGPoint(x: 300, y: 200)
        right.alpha = 0.5
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
