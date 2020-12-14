//
//  Player.swift
//  Miner
//
//  Created by Hollier, Alexander Phillip on 12/13/20.
//

import Foundation
import SpriteKit

class Player{
    var money: Int
    var digSpeed: Double
    var startDigCost: Int
    
    init(money: Int, digSpeed: Double, startDigCost: Int){
        self.money = money
        self.digSpeed = digSpeed
        self.startDigCost = startDigCost
    }
    
    func buyDigUpgrade(label: SKLabelNode){
        if money >= startDigCost{
            money -= startDigCost
            startDigCost *= 2
            digSpeed -= 0.2 * Double(digSpeed)
            label.text = "$\(money)"
        }
    }
}
