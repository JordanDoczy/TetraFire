//
//  BlockView.swift
//  TetraFire
//
//  Created by Jordan Doczy on 1/21/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import UIKit
import SpriteKit

class BlockView: UIView {
    
    var column = 0
    var row = 0
    var type: BlockType? = nil {
        didSet{
            guard let type = type else {
                isHidden = true
                overlay.backgroundColor = .clear
                return
            }
            
            overlay.alpha = 1
            //overlay.isHidden = false
            overlay.backgroundColor = type.color

            switch(type) {
            case .effect(effect: .fire):
                isHidden = true
                if let effectKeys = particleScene?.effects.keys {
                    if !effectKeys.contains(keyPrefix + EffectType.fire.fileName) {
                        fire(delay: 0.4)
                    }
                }
            case .activeBlock(_), .block(_), .ghost(_):
                isHidden = false
            default: break
            }
        }
    }
    
    var imageView = UIImageView(image: #imageLiteral(resourceName: "gradient"))
    var overlay = UIView()

    fileprivate var effectNodeManager = [EffectType : SKEmitterNode]()
    fileprivate var keyPrefix: String {
        return "Block:\(row):\(column):"
    }
    
    fileprivate var particleScene: ParticleScene? {
        return (UIApplication.shared.delegate as? AppDelegate)?.particleScene
    }
    
    fileprivate var point: CGPoint {
        guard let superview = superview else { return center }
        
        var point = center
        point.x += superview.frame.origin.x
        point.y += superview.frame.origin.y
        return point
    }

    override required init(frame: CGRect) {
        super.init(frame: frame)
        
        isOpaque = true
        overlay.frame = CGRect(origin: .zero, size: frame.size)
        addSubview(overlay)

        imageView.frame = CGRect(origin: .zero, size: frame.size)
        imageView.bounds = overlay.bounds
        imageView.alpha = 0.75
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func dowseFire() {
        var position = point
        position.y -= frame.height * 1.5
        
        smoke(delay: 0.5)
        rain(delay: 0, at: position)
        particleScene?.removeEffect(forKey: keyPrefix + EffectType.fire.fileName, delay:  0.7)
        AudioManager.shared.playSound(fileName: Assets.Sounds.dowseFire)
    }
    
    func dust(delay: Double = 0.0) {
        if let scene = particleScene {
            _ = scene.runEffect(forKey: keyPrefix + EffectType.dust.fileName,
                                effect: .dust,
                                position: scene.convertPoint(fromView: point),
                                duration:2.0,
                                delay: delay,
                                force: false)
        }
    }

    func explode(delay: Double = 0.0) {
        if let scene = particleScene {
            _ = scene.runEffect(forKey: keyPrefix + EffectType.explosion.fileName,
                                effect: .explosion,
                                position: scene.convertPoint(fromView: point),
                                duration: 2.0,
                                delay: delay,
                                force: false)
        }
    }
    
    func fire(delay: Double = 0.0, force: Bool = false) {
        if let scene = particleScene {
            _ = scene.runEffect(forKey: keyPrefix + EffectType.fire.fileName,
                                effect: .fire,
                                position: scene.convertPoint(fromView: point),
                                duration: -1.0,
                                delay: delay,
                                force: force)
        }
    }
    
    override func hide(with delay: Delay = 0.0, completion:((Bool) -> Void)? = nil) {
        //overlay.hide(with: delay, completion: completion)
    }
    
    func rain(delay: Double = 0.0, at position: CGPoint) {
        if let scene = particleScene {
            _ = scene.runEffect(forKey: keyPrefix + EffectType.rain.fileName,
                                effect: .rain,
                                position: scene.convertPoint(fromView: position),
                                duration: 2.0,
                                delay: delay,
                                force: false)
        }
    }
    
    override func show(with delay: Delay = 0.0, completion:((Bool) -> Void)? = nil) {
        //overlay.show(with: delay, completion: completion)
    }

    func smoke(delay: Double = 0.0) {
        if let scene = particleScene {
            _ = scene.runEffect(forKey: keyPrefix + EffectType.smoke.fileName,
                                effect: .smoke,
                                position: scene.convertPoint(fromView: point),
                                duration: 7.0,
                                delay: delay,
                                force: false)
        }
    }
}
