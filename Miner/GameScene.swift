//
//  GameScene.swift
//  Miner
//
//  Created by Hollier, Alexander Phillip on 12/2/20.
//

import SpriteKit

//tilesize for worldgen Tiles
let TILESIZE: Double = 75.0
//Groundlevel for Player
let GROUNDLEVEL: Double = 1055

// Driving class for the whole game.
// controls the SKScene, only contains overriden functions,
// extra functions are contained in other objects.
class GameScene: SKScene {
    //Control Pad Nodes
    var up = SKSpriteNode(imageNamed:"up")
    var left = SKSpriteNode(imageNamed:"left")
    var down = SKSpriteNode(imageNamed:"down")
    var right = SKSpriteNode(imageNamed:"right")
    //Money and resource label
    var resourceLabel = SKLabelNode(fontNamed: "Avenir-Black")
    //Player Variables and functions
    var playerState = Player(money: 0 ,digSpeed: 3.0, moveSpeed: 0.6, craftMultiplier: 1.0, startUpgradeCost: 250)
    //World Generation Functions
    var gen = Generation()
    //Load Atlas Animations
    var animations = Animate()
    //Movement and controll functions
    var controller = Controls()
    //Misc World Functions
    var worldFuncs = World()
    //Continuous Animated Nodes
    var player = SKSpriteNode()
    var conveyor = SKSpriteNode()
    var press = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        //add textures for nodes
        self.conveyor = self.childNode(withName: "conveyor") as! SKSpriteNode
        self.press = self.childNode(withName: "press") as! SKSpriteNode
        self.player = SKSpriteNode(texture: self.animations.frames["idle"]![0])
        //add animations for nodes
        self.conveyor.run(SKAction.repeatForever(self.animations.animations["conveyor"]!), withKey: "idleConveyor")
        self.player.run(SKAction.repeatForever(self.animations.animations["idle"]!), withKey: "idleAnimation")
        //generate world and spawn sprites
        self.worldFuncs.spawnSprites(scene: self)
        self.gen.generateStart(scene: self)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            let touchedNode = atPoint(touchLocation)
            
            //if truck clicked on ground level go to store
            if touchedNode.name == "truck"{
                controller.goShop(scene: self)
            }
            
            //if truck clicked at store go home
            if touchedNode.name == "truckStore"{
                controller.goHome(scene: self)
            }
            
            //buying pickaxe(digspeed) upgrade
            if touchedNode.name == "pickaxeBuy"{
                self.playerState.buyDigUpgrade()
                if let pLabel = self.childNode(withName: "pickaxePrice") as? SKLabelNode{
                    pLabel.text = "$\(self.playerState.upgradeCosts[0])"
                    worldFuncs.reloadSprites(scene: self)
                }
            }
            
            //buying boot(movespeed) upgrade
            if touchedNode.name == "bootsBuy"{
                self.playerState.buyBootUpgrade()
                if let pLabel = self.childNode(withName: "bootsPrice") as? SKLabelNode{
                    pLabel.text = "$\(self.playerState.upgradeCosts[1])"
                    worldFuncs.reloadSprites(scene: self)
                    self.animations.animations["walk"]!.duration = playerState.moveSpeed
                    self.animations.animations["climb"]!.duration = playerState.moveSpeed
                }
            }
            
            //buying crafting(money return) upgrade
            if touchedNode.name == "craftBuy"{
                self.playerState.buyCraftingUpgrade()
                if let pLabel = self.childNode(withName: "craftPrice") as? SKLabelNode{
                    pLabel.text = "$\(self.playerState.upgradeCosts[2])"
                    worldFuncs.reloadSprites(scene: self)
                    worldFuncs.updateMakeLabels(scene: self)
                }
            }
            
            //expand dropdown for resources
            if touchedNode == self.resourceLabel{
                if(self.resourceLabel.text == "$\(self.playerState.money)"){
                    worldFuncs.expandResource(scene: self)
                }
                else{
                    self.resourceLabel.text = "$\(self.playerState.money)"
                    self.resourceLabel.position = CGPoint(x: self.frame.size.width/20 + self.frame.width * CGFloat(self.gen.currentScreen) , y: self.frame.size.height * 0.9 + self.frame.height * CGFloat(-self.gen.currentLevel))
                }
            }
            
            //dig-move up
            if touchedNode == self.up{
                controller.moveUp(scene: self)
            }
            
            //dig-move down
            if touchedNode == self.down{
                controller.moveDown(scene: self)
            }
            
            //dig-move left
            if touchedNode == self.left{
                controller.moveLeft(scene: self)
            }
            
            //dig-move right
            if touchedNode == self.right{
                controller.moveRight(scene: self)
            }
            
            //clicking make for any material (determined in function)
            if let touchedNodeName = touchedNode.name{
                if touchedNodeName.contains("Make"){
                    worldFuncs.make(nodeName: touchedNode.name!, scene: self)
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
