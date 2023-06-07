//
//  Animate.swift
//  Miner
//
//  Created by Alex Hollier on 6/2/23.
//

import Foundation
import SpriteKit

// class loads all animations with .atlas types and allows access to
// dictionaries for their Texture array frames, and SKAction animations
class Animate{
    var frames: [String: [SKTexture]]
    var animations: [String: SKAction]
    
    // creates empty dictionaries, gets names of the atlac folders and
    // runs function to build animations
    init(){
        frames = [:]
        animations = [:]
        if let names = contentsOfDirectory(){
            buildAnimations(names: names)
        }
    }
    
    // Use bundle functions to find all directories with .atlas(.atlasc in bundle)
    // uses substrings to return only the name of the animation
    func contentsOfDirectory() -> [String]? {
        var animations: [String] = []
        let allPaths = Bundle.main.paths(forResourcesOfType: "atlasc", inDirectory: "")
        for path in allPaths {
            var animationName: String
            if let upper = path.range(of: "Miner.app/"), let lower = path.range(of: ".atlasc"){
                animationName = String(path[upper.upperBound..<lower.lowerBound])
                animations.append(animationName)
            }
        }
        return animations
    }
    
    //using the array of animation strings, builds frame arrays and
    //SKAction animatons and passes whem into class variables
    func buildAnimations(names: [String]){
        for name in names{
            let currAtlas = SKTextureAtlas(named: name)
            let numImages = currAtlas.textureNames.count
            var currFrames:[SKTexture] = []
            for i in 1...numImages {
                let currTextureName = "\(name)\(i)"
                currFrames.append(currAtlas.textureNamed(currTextureName))
            }
            self.frames.updateValue(currFrames, forKey: name)
            self.animations.updateValue(SKAction.animate(with: self.frames[name]!, timePerFrame: 0.3), forKey: name)
        }
    }
}
