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
                let allNodes = nodes(at: CGPoint(x: player.position.x, y: player.position.y + 100))
                
                dig(sprites: allNodes)
                
                player.position.y = player.position.y + 100
            }
            
            if touchedNode == down{
                let allNodes = nodes(at: CGPoint(x: player.position.x, y: player.position.y - 100))
                
                dig(sprites: allNodes)
                
                player.position.y = player.position.y - 100
            }
            
            if touchedNode == left{
                let allNodes = nodes(at: CGPoint(x: player.position.x - 100, y: player.position.y))
                
                dig(sprites: allNodes)
                
                player.position.x = player.position.x - 100
            }
            
            if touchedNode == right{
                let allNodes = nodes(at: CGPoint(x: player.position.x + 100, y: player.position.y))
                
                dig(sprites: allNodes)
                
                player.position.x = player.position.x + 100
            }
        }
    }
    
    func generateEarth(){
        var undergroundRow = [SKSpriteNode]()
        for m in 0...9{
            for n in 0...8{
                let block = weightedGen()
                let currentBlock = SKSpriteNode(imageNamed: block)
                let currentBG = SKSpriteNode(imageNamed: "stoneBG")
                currentBlock.name = block
                currentBlock.size = CGSize(width: 100, height: 100)
                currentBG.size = CGSize(width: 100, height: 100)
                currentBlock.position = CGPoint(x: 0 + 100*n, y: 100 + 100*m)
                currentBG.position = CGPoint(x: 0 + 100*n, y: 100 + 100*m)
                currentBlock.zPosition = 0
                currentBG.zPosition = -1
                self.addChild(currentBlock)
                self.addChild(currentBG)
            
                undergroundRow.append(currentBlock)
            }
            underground.append(undergroundRow)
        }
    }
    
    func weightedGen() -> String{
        let chance = Int.random(in: 1...100)
        switch chance {
        case 1...60:
            return "stone"
        case 61...70:
            return "dirt"
        case 71...80:
            return "copper"
        case 81...88:
            return "silver"
        case 89...96:
            return "gold"
        case 97...100:
            return "platinum"
        default:
            print("error with random")
            return "ERROR"
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
    
    func dig(sprites: [SKNode]){
        let types = ["stone","dirt","copper","silver","gold","platinum"]
        for sprite in sprites{
            if let spriteName = sprite.name{
                if types.contains(spriteName){
                    sprite.removeFromParent()
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
