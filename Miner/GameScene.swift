//
//  GameScene.swift
//  Miner
//
//  Created by Hollier, Alexander Phillip on 12/2/20.
//

import SpriteKit

var player = SKSpriteNode(imageNamed:"PlayerTEMP")

class GameScene: SKScene {

    
    override func didMove(to view: SKView) {
        
        spawnPlayer()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            
            player.position.x = touchLocation.x
        }
    }
    

    func spawnPlayer(){
        player.position = CGPoint(x: frame.width / 2, y: frame.height - 200)
        
        self.addChild(player)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
