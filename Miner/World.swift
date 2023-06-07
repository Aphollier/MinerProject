//
//  World.swift
//  Miner
//
//  Created by Alex Hollier on 6/6/23.
//

import Foundation
import SpriteKit

// Miscellaneous functions for the World
// primarily controls the initialization, destruction, and
// changes towards overworld sprites.
class World{
    
    // intialize non procedurally generated sprites
    func spawnSprites(scene: GameScene){
        //player sprite
        scene.player.position = CGPoint(x: TILESIZE/2 + TILESIZE * 4, y: GROUNDLEVEL)
        scene.player.zPosition = 1
        //controller sprites
        scene.down.position = CGPoint(x: 200, y: 200)
        scene.down.zPosition = 2
        scene.down.alpha = 0.5
        scene.up.position = CGPoint(x: 200, y: 300)
        scene.up.zPosition = 2
        scene.up.alpha = 0.5
        scene.left.position = CGPoint(x: 100, y: 200)
        scene.left.zPosition = 2
        scene.left.alpha = 0.5
        scene.right.position = CGPoint(x: 300, y: 200)
        scene.right.alpha = 0.5
        scene.right.zPosition = 2
        //money-resource label
        scene.resourceLabel.numberOfLines = 0
        scene.resourceLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        scene.resourceLabel.position = CGPoint(x: scene.frame.size.width/20, y: scene.frame.size.height * 0.9)
        scene.resourceLabel.zPosition = 6
        scene.resourceLabel.text = "$\(scene.playerState.money)"
        scene.resourceLabel.fontColor = UIColor.black
        scene.resourceLabel.horizontalAlignmentMode = .left
        scene.resourceLabel.verticalAlignmentMode = .top
        //pickaxe upgrade variable price
        if let pLabel = scene.childNode(withName: "pickaxePrice") as? SKLabelNode{
            pLabel.text = "$\(scene.playerState.upgradeCosts[0])"
        }
        //boot upgrade variable price
        if let pLabel = scene.childNode(withName: "bootsPrice") as? SKLabelNode{
            pLabel.text = "$\(scene.playerState.upgradeCosts[1])"
        }
        //crafting upgrade variable price
        if let pLabel = scene.childNode(withName: "craftPrice") as? SKLabelNode{
            pLabel.text = "$\(scene.playerState.upgradeCosts[2])"
        }
        //adding sprites to scene
        scene.addChild(scene.player)
        scene.addChild(scene.down)
        scene.addChild(scene.up)
        scene.addChild(scene.left)
        scene.addChild(scene.right)
        scene.addChild(scene.resourceLabel)
        //initializing variable make returns
        updateMakeLabels(scene: scene)
    }
    
    //reload the sprites for the controller and resource label in order to
    //properly manage their positions between screen swaps
    func reloadSprites(scene: GameScene){
        scene.down.position = CGPoint(x: 200 + scene.frame.width * CGFloat(scene.gen.currentScreen), y: 200 + scene.frame.height * CGFloat(-scene.gen.currentLevel))
        scene.up.position = CGPoint(x: 200 + scene.frame.width * CGFloat(scene.gen.currentScreen), y: 300 + scene.frame.height * CGFloat(-scene.gen.currentLevel))
        scene.left.position = CGPoint(x: 100 + scene.frame.width * CGFloat(scene.gen.currentScreen), y: 200 + scene.frame.height * CGFloat(-scene.gen.currentLevel))
        scene.right.position = CGPoint(x: 300 + scene.frame.width * CGFloat(scene.gen.currentScreen), y: 200 + scene.frame.height * CGFloat(-scene.gen.currentLevel))
        if scene.resourceLabel.text!.contains("Stone"){
            expandResource(scene: scene)
        }
        else{
            scene.resourceLabel.text = "$\(scene.playerState.money)"
            scene.resourceLabel.position = CGPoint(x: scene.frame.size.width/20 + scene.frame.width * CGFloat(scene.gen.currentScreen), y: scene.frame.size.height * 0.9 + scene.frame.height * CGFloat(-scene.gen.currentLevel))
        }
    }
    
    //function used to discern and check which material to make
    //and whether player can make it. Function dished out rewards
    //and runs animation function.
    func make(nodeName: String, scene: GameScene){
        let prices = ["stone": 1,
                      "dirt": 1,
                      "copper": 10,
                      "nickel": 20,
                      "zinc": 30,
                      "iron": 50,
                      "silver": 100,
                      "gold": 500]
        let node = String(nodeName.dropLast(4))
        if(scene.playerState.resources[node]! > 0){
            scene.playerState.resources[node]! -= 1
            let reward = Double(prices[node]!) * scene.playerState.craftMultiplier
            scene.playerState.money += Int(round(reward))
            makeAnimate(name: node, scene: scene)
        }
        reloadSprites(scene: scene)
    }
    
    //Using passed in string name function runs animations for short lived crafted
    //material sprites using sprite names to discern which animation to run
    func makeAnimate(name: String, scene: GameScene){
        let colors:[String: [Any]] = [
                    "copper": [UIColor.brown, CGFloat(0.9), CGFloat(70)],
                    "nickel": [UIColor.gray, CGFloat(0.4), CGFloat(75)],
                    "zinc": [UIColor.gray, CGFloat(0.4), CGFloat(65)],
                    "iron": [UIColor.gray, CGFloat(0.4), CGFloat(80)],
                    "silver": [UIColor.gray, CGFloat(0.5), CGFloat(85)],
                    "gold": [UIColor.yellow, CGFloat(0.6), CGFloat(90)]
                    ]
        
        var newMake = SKSpriteNode()
        let pressDrop = SKAction.move(to: CGPoint(x: scene.conveyor.position.x, y: scene.conveyor.position.y - 75), duration: 0.1)
        let pressRise = SKAction.move(to: CGPoint(x: scene.conveyor.position.x, y: scene.conveyor.position.y), duration: 0.1)
        scene.press.run(SKAction.sequence([pressDrop, pressRise]))
        
        if name == "stone"{
            newMake = SKSpriteNode(imageNamed: "stoneMake1")
            newMake.position = CGPoint(x: scene.conveyor.position.x - scene.conveyor.size.width/4, y: scene.conveyor.position.y - 5)
            newMake.zPosition = 0.2
            scene.addChild(newMake)
            newMake.run(SKAction.repeatForever(scene.animations.animations["stoneMake"]!))
        }
        else if name == "dirt"{
            newMake = SKSpriteNode(imageNamed: "dirtMake1")
            newMake.position = CGPoint(x: scene.conveyor.position.x - scene.conveyor.size.width/4, y: scene.conveyor.position.y - 5)
            newMake.zPosition = 0.2
            scene.addChild(newMake)
            newMake.run(SKAction.repeatForever(scene.animations.animations["dirtMake"]!))
        }
        else{
            newMake = SKSpriteNode(imageNamed: "makeWalk1")
            newMake.position = CGPoint(x: scene.conveyor.position.x - scene.conveyor.size.width/4, y: scene.conveyor.position.y - 5)
            newMake.zPosition = 0.2
            newMake.color = colors[name]![0] as! UIColor
            newMake.colorBlendFactor = colors[name]![1] as! CGFloat
            newMake.size.width = colors[name]![2] as! CGFloat
            newMake.size.height = colors[name]![2] as! CGFloat
            scene.addChild(newMake)
            newMake.run(SKAction.repeatForever(scene.animations.animations["makeWalk"]!))
        }
        
        let moveLeft = SKAction.move(to: CGPoint(x: scene.conveyor.position.x + scene.conveyor.size.width/2, y: scene.conveyor.position.y - 5), duration: 1)
        let drop = SKAction.move(to: CGPoint(x: scene.conveyor.position.x + scene.conveyor.size.width/2, y: 1014 + newMake.size.height/2), duration: 0.2)
        let offscreen = SKAction.move(to: CGPoint(x: scene.frame.width * CGFloat(scene.gen.currentScreen + 1) + newMake.size.width, y: 1014 + newMake.size.height/2), duration: 1)
        newMake.run(SKAction.sequence([moveLeft, drop, offscreen])){
            newMake.removeFromParent()
        }
    }
    
    // Expands drop down menu for resource label
    func expandResource(scene: GameScene){
        scene.resourceLabel.text = "$\(scene.playerState.money)\n" +
        "Stone: \(scene.playerState.resources["stone"]!)\n" +
        "Dirt: \(scene.playerState.resources["dirt"]!)\n" +
        "Cu: \(scene.playerState.resources["copper"]!)\n" +
        "Ni: \(scene.playerState.resources["nickel"]!)\n" +
        "Zn: \(scene.playerState.resources["zinc"]!)\n" +
        "Fe: \(scene.playerState.resources["iron"]!)\n" +
        "Ag: \(scene.playerState.resources["silver"]!)\n" +
        "Au: \(scene.playerState.resources["gold"]!)"
        scene.resourceLabel.position = CGPoint(x: scene.frame.size.width/20 + scene.frame.width * CGFloat(scene.gen.currentScreen), y: scene.frame.size.height * 0.9 + scene.frame.height * CGFloat(-scene.gen.currentLevel))
    }
    
    //updates reward labels for crafting when crafting upgrades are
    //bought or when labels are being initialized
    func updateMakeLabels(scene: GameScene){
        let prices = ["stone": 1,
                      "dirt": 1,
                      "copper": 10,
                      "nickel": 20,
                      "zinc": 30,
                      "iron": 50,
                      "silver": 100,
                      "gold": 500]
        for (mat, price) in prices{
            if let pLabel = scene.childNode(withName: "\(mat)Reward") as? SKLabelNode{
                let reward = Double(price) * scene.playerState.craftMultiplier
                pLabel.text = "+$\(Int(round(reward)))"
            }
        }
    }
}
