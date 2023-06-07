//
//  Player.swift
//  Miner
//
//  Created by Hollier, Alexander Phillip on 12/13/20.
//

import Foundation
import SpriteKit

// Class that holds player variables and updates them through
// bought upgrades
class Player{
    var money: Int
    var digSpeed: Double
    var moveSpeed: Double
    var craftMultiplier: Double
    var upgradeCosts: [Int]
    var resources: [String: Int]
    
    //uses passed in initialization values to give make player starting stats
    init(money: Int, digSpeed: Double, moveSpeed: Double, craftMultiplier: Double, startUpgradeCost: Int){
        self.money = money
        self.digSpeed = digSpeed
        self.moveSpeed = moveSpeed
        self.craftMultiplier = craftMultiplier
        self.upgradeCosts = [Int](repeating: startUpgradeCost, count: 3)
        self.resources = ["stone": 0, "dirt": 0,
                          "copper": 0, "nickel": 0, "zinc": 0,
                          "iron": 0, "silver": 0, "gold": 0]
    }
    
    //lowers dig time by lowering digspeed var and increases digspeed
    //upgrade cost
    func buyDigUpgrade(){
        if money >= upgradeCosts[0]{
            money -= upgradeCosts[0]
            upgradeCosts[0] *= 2
            digSpeed -= 0.2 * Double(digSpeed)
        }
    }
    
    //increases movespeed by lowering movespeed var and increases movespeed
    //upgraade cost
    func buyBootUpgrade(){
        if money >= upgradeCosts[1]{
            money -= upgradeCosts[1]
            upgradeCosts[1] *= 2
            moveSpeed = moveSpeed * 0.9
        }
    }
    
    //increases crafting returns by increases craftMultiplier var
    //increases crafting upgrade cost
    func buyCraftingUpgrade(){
        if money >= upgradeCosts[2]{
            money -= upgradeCosts[2]
            upgradeCosts[2] *= 2
            craftMultiplier += 0.5
        }
    }
}
