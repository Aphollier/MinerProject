//
//  Controls.swift
//  Miner
//
//  Created by Alex Hollier on 6/6/23.
//

import Foundation
import SpriteKit

// Class contains functions pertaining to movement of the player sprite
class Controls{
    
    //If player is not at GROUNDLEVEL move up one tile, if tile contains a
    //mineable tile, run dig. Runs appropriate animations
    func moveUp(scene: GameScene){
        if scene.player.position.y < GROUNDLEVEL{
            scene.isUserInteractionEnabled = false
            let allNodes = scene.nodes(at: CGPoint(x: scene.player.position.x, y: scene.player.position.y + TILESIZE))
            scene.player.run(SKAction.repeatForever(scene.animations.animations["mineup"]!), withKey: "mine")
            dig(sprites: allNodes, scene: scene){
                scene.player.removeAction(forKey: "mine")
                let moveUp = SKAction.move(to: CGPoint(x: scene.player.position.x, y: scene.player.position.y + TILESIZE), duration: scene.animations.animations["climb"]!.duration)
                scene.player.run(SKAction.group([scene.animations.animations["climb"]!, moveUp])){
                    scene.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    //Move player down one tile, if tile contains a mineable tile, run dig.
    //Runs appropiate animations. Cannot move down on house screen
    func moveDown(scene: GameScene){
        if scene.gen.currentScreen == 0{
            scene.isUserInteractionEnabled = false
            let allNodes = scene.nodes(at: CGPoint(x: scene.player.position.x, y: scene.player.position.y - TILESIZE))
            scene.player.run(SKAction.repeatForever(scene.animations.animations["minedown"]!), withKey: "mine")
            dig(sprites: allNodes, scene: scene) {
                scene.player.removeAction(forKey: "mine")
                let moveDown = SKAction.move(to: CGPoint(x: scene.player.position.x, y: scene.player.position.y - TILESIZE), duration: scene.animations.animations["climb"]!.duration)
                scene.player.run(SKAction.group([scene.animations.animations["climb"]!, moveDown])){
                    scene.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    //If Player isn't going to move offscreen, move player left. If mineable tile
    //blocks player, run dig. If player will move offscreen, but player is on house screen
    //move player left onto mine screen and move screen. Runs appropriate animations
    func moveLeft(scene: GameScene){
        if scene.player.position.x - TILESIZE > 0 + scene.frame.width * CGFloat(scene.gen.currentScreen){
            scene.isUserInteractionEnabled = false
            let flipLeft = SKAction.scaleX(to: 1, y: 1, duration:0)
            scene.player.run(SKAction.repeatForever(SKAction.group([flipLeft, scene.animations.animations["mine"]!])), withKey: "mine")
            let allNodes = scene.nodes(at: CGPoint(x: scene.player.position.x - TILESIZE, y: scene.player.position.y))
            dig(sprites: allNodes, scene: scene){
                scene.player.removeAction(forKey: "mine")
                let moveLeft = SKAction.move(to: CGPoint(x: scene.player.position.x - TILESIZE, y: scene.player.position.y), duration: scene.animations.animations["walk"]!.duration)
                scene.player.run(SKAction.group([scene.animations.animations["walk"]!, moveLeft, flipLeft])){
                    scene.isUserInteractionEnabled = true
                }
            }
        }
        else if scene.gen.currentScreen == 1{
            scene.isUserInteractionEnabled = false
            let flipLeft = SKAction.scaleX(to: 1, y: 1, duration:0)
            let moveLeft = SKAction.move(to: CGPoint(x: scene.player.position.x - TILESIZE, y: scene.player.position.y), duration: scene.animations.animations["walk"]!.duration)
            scene.gen.currentScreen -= 1
            scene.anchorPoint = CGPoint(x: -scene.gen.currentScreen, y:scene.gen.currentLevel)
            scene.worldFuncs.reloadSprites(scene: scene)
            scene.player.run(SKAction.group([scene.animations.animations["walk"]!, moveLeft, flipLeft])){
                scene.isUserInteractionEnabled = true
            }
        }
    }
    
    //If Player isn't going to move offscreen, move player right. If mineable tile
    //blocks player, run dig. If player will move offscreen, but player is on mine screen
    //move player right onto house screen and move screen. Runs appropriate animations
    func moveRight(scene: GameScene){
        if scene.player.position.x + TILESIZE < scene.frame.width * CGFloat(scene.gen.currentScreen + 1) {
            scene.isUserInteractionEnabled = false
            let flipRight = SKAction.scaleX(to: -1, y: 1, duration:0)
            scene.player.run(SKAction.repeatForever(SKAction.group([flipRight, scene.animations.animations["mine"]!])), withKey: "mine")
            let allNodes = scene.nodes(at: CGPoint(x: scene.player.position.x + TILESIZE, y: scene.player.position.y))
            dig(sprites: allNodes, scene: scene){
                scene.isUserInteractionEnabled = false
                scene.player.removeAction(forKey: "mine")
                let moveRight = SKAction.move(to: CGPoint(x: scene.player.position.x + TILESIZE, y: scene.player.position.y), duration: scene.animations.animations["walk"]!.duration)
                scene.player.run(SKAction.group([scene.animations.animations["walk"]!, moveRight, flipRight])){
                    scene.isUserInteractionEnabled = true
                }
            }
        }
        else if scene.nodes(at:scene.player.position).contains(scene.childNode(withName: "sign")!) {
            scene.isUserInteractionEnabled = false
            let flipRight = SKAction.scaleX(to: -1, y: 1, duration:0)
            let moveRight = SKAction.move(to: CGPoint(x: scene.player.position.x + TILESIZE, y: scene.player.position.y), duration:scene.animations.animations["walk"]!.duration)
            scene.gen.currentScreen += 1
            scene.anchorPoint = CGPoint(x: -scene.gen.currentScreen, y:scene.gen.currentLevel)
            scene.worldFuncs.reloadSprites(scene: scene)
            scene.player.run(SKAction.group([scene.animations.animations["walk"]!, moveRight, flipRight])){
                scene.isUserInteractionEnabled = true
            }
        }
    }
    
    //Dig the sprite passed in, pausing the game while tile is being dug.
    //dished out proper resource to the players resources. if player is going to change
    //vertical levels, move screen.
    func dig(sprites: [SKNode], scene: GameScene, completed: @escaping () -> Void){
        let types = ["stone","dirt","copper","nickel","zinc","iron","silver","gold"]
        for sprite in sprites{
            if let spriteName = sprite.name{
                if types.contains(spriteName){
                    scene.playerState.resources[spriteName]! += 1
                    scene.isUserInteractionEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + scene.playerState.digSpeed){
                        sprite.removeFromParent()
                        if(scene.resourceLabel.text != "$\(scene.playerState.money)"){
                            scene.worldFuncs.expandResource(scene: scene)
                        }
                        completed()
                    }
                    return
                }
                else if spriteName.contains("level"){
                    if(spriteName.contains("\(scene.gen.currentLevel)")){
                        scene.gen.currentLevel -= 1
                        scene.anchorPoint = CGPoint(x: 0, y:scene.gen.currentLevel)
                        scene.worldFuncs.reloadSprites(scene: scene)
                        scene.player.position.y = scene.player.position.y + 133.33
                        
                    }
                    else{
                        scene.gen.currentLevel += 1
                        scene.anchorPoint = CGPoint(x: 0, y:scene.gen.currentLevel)
                        scene.worldFuncs.reloadSprites(scene: scene)
                        if scene.gen.currentLevel > scene.gen.levelMax{
                            scene.gen.generateLevel(scene: scene)
                        }
                        
                        scene.player.position.y = scene.player.position.y - 133.33
                    }
                }
            }
        }
        completed()
    }
    
    //move player to store screen, change screen anchor, hide controller
    func goShop(scene: GameScene){
        if scene.player.position.y == GROUNDLEVEL{
            scene.gen.currentScreen -= 1
            scene.anchorPoint = CGPoint(x: -scene.gen.currentScreen, y:scene.gen.currentLevel)
            scene.player.position = CGPoint(x: -400, y: 700)
            scene.worldFuncs.reloadSprites(scene: scene)
            scene.up.isHidden = true
            scene.down.isHidden = true
            scene.left.isHidden = true
            scene.right.isHidden = true
        }
    }
    
    //move player back to mine screen, change screen anchor, reveal controller
    func goHome(scene: GameScene){
        scene.gen.currentScreen += 1
        scene.anchorPoint = CGPoint(x: -scene.gen.currentScreen, y: scene.gen.currentLevel)
        scene.player.position = CGPoint(x: TILESIZE/2 + TILESIZE * 4, y: GROUNDLEVEL)
        scene.worldFuncs.reloadSprites(scene: scene)
        scene.up.isHidden = false
        scene.down.isHidden = false
        scene.left.isHidden = false
        scene.right.isHidden = false
    }
}
