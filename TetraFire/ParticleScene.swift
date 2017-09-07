//
//  ParticleScene.swift
//  TetraFire
//
//  Created by Jordan Doczy on 1/21/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import UIKit
import SpriteKit

class ParticleScene: SKScene {
    
    fileprivate(set) var actions = [String : SKAction]()
    fileprivate(set) var effects = [String : SKEmitterNode]()
    
    override required init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func removeAllChildren() {
        super.removeAllChildren()
        effects.removeAll()
    }
    
    func removeEffect(forKey key: String, delay: Double = 0.0){
        
        if delay > 0 {
            run(SKAction.wait(forDuration: delay),
                completion: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.effects[key]?.removeFromParent()
                    strongSelf.effects.removeValue(forKey: key)
                }
            )
        } else {
            effects[key]?.removeFromParent()
            effects.removeValue(forKey: key)
        }
    }
    
    func runEffect(forKey key: String,
                   effect: EffectType,
                   position: CGPoint = .zero,
                   duration : Double = -1.0,
                   delay: Double = 0.0,
                   force: Bool = false) -> SKEmitterNode? {
        
        if effects[key] == nil || force {
            removeEffect(forKey: key)
            effects[key] = SKEmitterNode(fileNamed: effect.fileName)
            effects[key]?.particlePosition = position
            
            removeAction(forKey: key)
            actions[key] = SKAction.wait(forDuration: delay)
            
            run(actions[key]!) { [weak self] in
                guard let strongSelf = self else { return }
                
                if let skNode = strongSelf.effects[key] {
                    skNode.resetSimulation()
                    strongSelf.addChild(skNode)
                }
            }
            
            if duration >= 0 {
                removeEffect(forKey: key, delay: duration + delay)
            }
            
            return effects[key]
        }
        
        return nil
    }
}
