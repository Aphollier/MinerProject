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
var moneyLabel = SKLabelNode(fontNamed: "Avenir-Black")
var playerState = Player(money: 0 , digSpeed: 3.0, startDigCost: 250)
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
            
            if touchedNode.name == "store"{
                self.childNode(withName: "storeOverlay")?.alpha = 1
                self.childNode(withName: "storeLabel")?.alpha = 1
                self.childNode(withName: "digLabel")?.alpha = 1
                self.childNode(withName: "digButton")?.alpha = 1
                self.childNode(withName: "exit")?.alpha = 1
                self.childNode(withName: "priceLabel")?.alpha = 1
            }
            
            if touchedNode.name == "digButton"{
                playerState.buyDigUpgrade(label: moneyLabel)
                if let pLabel = self.childNode(withName: "priceLabel") as? SKLabelNode{
                    pLabel.text = "$\(playerState.startDigCost)"
                }
            }
            
            if touchedNode.name == "exit"{
                self.childNode(withName: "storeOverlay")?.alpha = 0
                self.childNode(withName: "storeLabel")?.alpha = 0
                self.childNode(withName: "digLabel")?.alpha = 0
                self.childNode(withName: "digButton")?.alpha = 0
                self.childNode(withName: "exit")?.alpha = 0
                self.childNode(withName: "priceLabel")?.alpha = 0
            }
            
            if touchedNode == up{
                let allNodes = nodes(at: CGPoint(x: player.position.x, y: player.position.y + 100))
                
                dig(sprites: allNodes){
                    player.position.y = player.position.y + 100
                }
                
            }
            
            if touchedNode == down{
                let allNodes = nodes(at: CGPoint(x: player.position.x, y: player.position.y - 100))
                
                dig(sprites: allNodes) {
                    player.position.y = player.position.y - 100
                }
            }
            
            if touchedNode == left{
                let allNodes = nodes(at: CGPoint(x: player.position.x - 100, y: player.position.y))
                dig(sprites: allNodes){
                    player.position.x = player.position.x - 100

                }
            }
            
            if touchedNode == right{
                let allNodes = nodes(at: CGPoint(x: player.position.x + 100, y: player.position.y))
                dig(sprites: allNodes){
                    player.position.x = player.position.x + 100
                }
            }
        }
    }
    
    func generateEarth(){
        var undergroundRow = [SKSpriteNode]()
        for m in 0...9{
            for n in -1...9{
                var block: String
                var currentBlock:SKSpriteNode
                if n == -1 || n == 9{
                    block = "bounds"
                    currentBlock = SKSpriteNode(imageNamed: "ERROR")
                }
                else{
                    block = weightedGen()
                    currentBlock = SKSpriteNode(imageNamed: block)
                }
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
        moneyLabel.position = CGPoint(x: self.frame.size.width/2, y: 1200)
        moneyLabel.zPosition = 6
        moneyLabel.text = "$\(playerState.money)"
        moneyLabel.fontColor = UIColor.black
        if let pLabel = self.childNode(withName: "priceLabel") as? SKLabelNode{
            pLabel.text = "$\(playerState.startDigCost)"
        }
        
        self.addChild(player)
        self.addChild(down)
        self.addChild(up)
        self.addChild(left)
        self.addChild(right)
        self.addChild(moneyLabel)
        
    }
    
    func dig(sprites: [SKNode], completed: @escaping () -> Void){
        let types = ["stone","dirt","copper","silver","gold","platinum"]
        for sprite in sprites{
            if let spriteName = sprite.name{
                if types.contains(spriteName){
                    switch spriteName {
                    case "stone":
                        playerState.money += 5
                    case "dirt":
                        playerState.money += 1
                    case "copper":
                        playerState.money += 50
                    case "silver":
                        playerState.money += 100
                    case "gold":
                        playerState.money += 250
                    case "platinum":
                        playerState.money += 500
                    default:
                        print("error destroying ground")
                    }
                    isUserInteractionEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + playerState.digSpeed){
                        sprite.removeFromParent()
                        moneyLabel.text = ("$\(playerState.money)")
                        completed()
                    }
                    isUserInteractionEnabled = true
                    return
                }
                else if spriteName == "bounds"{
                    return
                }
            }
        }
        completed()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
