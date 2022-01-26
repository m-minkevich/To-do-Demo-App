//
//  UIButton+Extension.swift
//  To-do Demo App
//
//  Created by Matt Minkevich on 24/01/2022.
//

import UIKit

extension UIButton {
    
    convenience init(title: String = "Button", backgroundColor: UIColor = .systemBlue) {
        self.init(type: .system)
        self.backgroundColor = backgroundColor
        
        self.setTitle(title, for: .normal)
        
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.darkGray, for: .disabled)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        self.heightAnchor.constraint(equalToConstant: 28).isActive = true
        self.layer.cornerRadius = 14
        
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12);
    }
    
}
