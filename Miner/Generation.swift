//
//  Generation.swift
//  Miner
//
//  Created by Alex Hollier on 6/2/23.
//

import Foundation
import SpriteKit

// Class generates all digable tiles in the game procedurally
// using weighted generation
class Generation{
    var currentLevel: Int
    var currentScreen: Int
    var levelMax: Int
    var underground: [[SKSpriteNode]]
    
    init(){
        currentLevel = 0
        currentScreen = 0
        levelMax = 0
        underground = [[SKSpriteNode]]()
    }
    
    // generate start level with fewer nodes leaving space for starting above ground
    // area
    func generateStart(scene: GameScene){
        var undergroundRow = [SKSpriteNode]()
        for m in (-1...12).reversed(){
            for n in 0...9{
                var block: String
                var currentBlock:SKSpriteNode
                if m == -1{
                    block = "level1"
                    currentBlock = SKSpriteNode(imageNamed: "ERROR")
                }
                else if m == 0{
                    block = "buffer"
                    currentBlock = SKSpriteNode(imageNamed: "buffer")
                }
                else if m == 12{
                    block = "dirt"
                    currentBlock = SKSpriteNode(imageNamed: "grass")
                }
                else if m == 11{
                    block = "dirt"
                    currentBlock = SKSpriteNode(imageNamed: "dirt")
                }
                else{
                    let aboveName = scene.atPoint(CGPoint(x: TILESIZE/2 + TILESIZE*Double(n), y:TILESIZE + TILESIZE*Double(m-1))).name
                    let besideName = scene.atPoint(CGPoint(x: TILESIZE/2 + TILESIZE*Double(n-1), y:TILESIZE + TILESIZE*Double(m))).name
                    block = weightedGen(beside: besideName, above: aboveName)
                    currentBlock = SKSpriteNode(imageNamed: block)
                }
                let currentBG = SKSpriteNode(imageNamed: "bgDirt")
                currentBlock.name = block
                currentBlock.size = CGSize(width: TILESIZE, height: TILESIZE)
                currentBG.size = CGSize(width: TILESIZE, height: TILESIZE)
                currentBlock.position = CGPoint(x: TILESIZE/2 + TILESIZE*Double(n), y: TILESIZE + TILESIZE*Double(m))
                currentBG.position = CGPoint(x: TILESIZE/2 + TILESIZE*Double(n), y: TILESIZE + TILESIZE*Double(m))
                currentBlock.zPosition = 0
                currentBG.zPosition = -1
                scene.addChild(currentBlock)
                scene.addChild(currentBG)
            
                undergroundRow.append(currentBlock)
            }
            underground.append(undergroundRow)
        }
    }
    
    // generates lower levels that fill almost the entire screen
    func generateLevel(scene: GameScene){
        self.levelMax += 1
        let movement =  scene.frame.height * CGFloat(-levelMax)
        var undergroundRow = [SKSpriteNode]()
        for m in -1...15{
            for n in 0...9{
                var block: String
                var currentBlock:SKSpriteNode
                if m == -1{
                    block = "level\(levelMax+1)"
                    currentBlock = SKSpriteNode(imageNamed: "ERROR")
                }
                else if m == 0 || m == 15{
                    block = "buffer"
                    currentBlock = SKSpriteNode(imageNamed: "buffer")
                }
                else{
                    let aboveName = scene.atPoint(CGPoint(x: TILESIZE/2 + TILESIZE*Double(n), y:TILESIZE + TILESIZE*Double(m-1))).name
                    let besideName = scene.atPoint(CGPoint(x: TILESIZE/2 + TILESIZE*Double(n-1), y:TILESIZE + TILESIZE*Double(m))).name
                    block = weightedGen(beside: besideName, above: aboveName)
                    currentBlock = SKSpriteNode(imageNamed: block)
                }
                let currentBG = SKSpriteNode(imageNamed: "bgStone")
                currentBlock.name = block
                currentBlock.size = CGSize(width: TILESIZE, height: TILESIZE)
                currentBG.size = CGSize(width: TILESIZE, height: TILESIZE)
                currentBlock.position = CGPoint(x: TILESIZE/2 + TILESIZE*Double(n), y: TILESIZE + TILESIZE*Double(m) + movement)
                currentBG.position = CGPoint(x: TILESIZE/2 + TILESIZE*Double(n), y: TILESIZE + TILESIZE*Double(m) + movement)
                currentBlock.zPosition = 0
                currentBG.zPosition = -1
                scene.addChild(currentBlock)
                scene.addChild(currentBG)
            
                undergroundRow.append(currentBlock)
            }
            underground.append(undergroundRow)
        }
    }
    
    // decides which tile to generate given nearby tiles
    func weightedGen(beside: String?, above: String?) -> String{
        var choices = ["stone": 3000,
                       "dirt": 400,
                       "copper": 300,
                       "nickel": 200,
                       "zinc": 200,
                       "iron": 150,
                       "silver": 100,
                       "gold": 50]
        if let beside = beside {
            if choices[beside] != nil && beside != "stone" {
                choices[beside]! *= 5
            }
        }
        if let above = above {
            if choices[above] != nil && above != "stone" {
                choices[above]! *= 5
            }
        }
        
        let total = choices.values.reduce(0, +)
        let rnd = Int.random(in: 0...total)
        var accWeight = 0
        for (key, weight) in choices{
            accWeight += weight
            if rnd <= accWeight{
                return key
            }
        }
        return "error"
    }
    
}
