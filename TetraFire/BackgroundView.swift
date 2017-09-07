//
//  BackgroundView.swift
//  TetraFire
//
//  Created by Jordan Doczy on 2/6/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import UIKit

class BackgroundView : UIView {

    internal lazy var imageView: UIImageView = { [unowned self] in
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.backgroundColor = .black
        imageView.frame = self.frame
        return imageView
        }()

    internal var model = [
        #imageLiteral(resourceName: "milkyway"),
        #imageLiteral(resourceName: "venus"),
        #imageLiteral(resourceName: "fire"),
        #imageLiteral(resourceName: "mars"),
        #imageLiteral(resourceName: "galaxy"),
        #imageLiteral(resourceName: "pluto"),
        #imageLiteral(resourceName: "sun"),
        #imageLiteral(resourceName: "earth"),
        #imageLiteral(resourceName: "space")
    ]
    
    fileprivate var currentIndex = 0 {
        didSet{
            // currentIndex not in range
            if !(0 ..< model.count ~= currentIndex) {
                currentIndex = 0
            }
            
            imageView.image = model[currentIndex]
            imageView.contentMode = .center
        }
    }
    
    fileprivate var performEffect: Bool = false
    
    override required init(frame: CGRect) {
        defer {
            currentIndex = Int(arc4random_uniform(UInt32(model.count)))
        }

        super.init(frame: frame)
        backgroundColor = .black
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        layer.removeAllAnimations()
    }
    
    func animationCompleted() {
        guard performEffect == true else {
            return
        }
        
        imageView.hide() { [weak self] success in
            guard let strongSelf = self else { return }

            strongSelf.currentIndex += 1
            strongSelf.imageView.show()
            strongSelf.startAnimating()
        }
    }
    
    func startAnimating() {
        performEffect = true
        
        let range = 50
        
        let x = arc4random_uniform(2) == 1
            ? Int(arc4random_uniform(UInt32(range / 2))) + range
            : -Int(arc4random_uniform(UInt32(range / 2))) - range
        
        let y = arc4random_uniform(2) == 1
            ? Int(arc4random_uniform(UInt32(range / 2))) + range
            : -Int(arc4random_uniform(UInt32(range / 2))) - range
        
        let scale = 1 + CGFloat(arc4random_uniform(3) + 1) / 10
        
        UIView.animate(withDuration: 60,
            delay: 0.0,
            options: [.curveLinear],
            animations: { [weak self] in
                self?.transform = CGAffineTransform(scaleX: CGFloat(scale),
                                                    y: CGFloat(scale)).translatedBy(x: CGFloat(x), y: CGFloat(y))
            },
            completion: { [weak self] success in
                self?.animationCompleted()
            }
        )
    }
    
    func stopAnimating() {
        performEffect = false
    }
}
