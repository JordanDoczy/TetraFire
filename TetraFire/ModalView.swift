//
//  ModalView.swift
//  TetraFire
//
//  Created by Jordan Doczy on 2/1/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import UIKit

protocol ModalViewDelegate: class {
    func modalViewDidHide(modalView: ModalView)
    func modalViewDidShow(modalView: ModalView)
    func modalViewWillHide(modalView: ModalView)
    func modalViewWillShow(modalView: ModalView)
}

class ModalView: UIView{
    
    weak var delegate: ModalViewDelegate?

    var message: String = "" {
        didSet {
            label.removeFromSuperview()
            label.text = message
            addSubview(label)
        }
    }
    
    fileprivate lazy var label: UILabel = { [unowned self] in
        let label = UILabel()
        label.numberOfLines = -1
        label.frame.size.height = self.frame.height * 0.9
        label.frame.size.width = self.frame.width * 0.8
        label.frame.origin.x = self.frame.width * 0.05
        label.textAlignment = .left
        label.textColor = .text
        label.font = .modal
        label.isUserInteractionEnabled = false
        return label
    }()
    
    override required init(frame: CGRect) {
        super.init(frame: frame)

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func close() {
        hide()
    }
    
    override func hide(with delay: Delay = 0.0, completion: ((Bool)->Void)? = nil) {
        delegate?.modalViewWillHide(modalView: self)
        
        super.hide(with: delay) { [weak self] success in
            guard let strongSelf = self else {
                completion?(success)
                return
            }
            
            strongSelf.delegate?.modalViewDidHide(modalView: strongSelf)
            completion?(success)
        }
    }
    
    override func show(with delay: Delay = 0.0, completion: ((Bool)->Void)? = nil) {
        delegate?.modalViewWillShow(modalView: self)
        
        super.show(with: 0.5) { [weak self] success in
            guard let strongSelf = self else {
                completion?(success)
                return
            }
            
            strongSelf.delegate?.modalViewDidShow(modalView: strongSelf)
            completion?(success)
        }
    }
}
