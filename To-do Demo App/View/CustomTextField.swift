//
//  CustomTextField.swift
//  To-do Demo App
//
//  Created by Matt Minkevich on 20/01/2022.
//

import UIKit

class CustomTextField: UITextField {
    
    let height: CGFloat

    init(height: CGFloat = 50) {
        self.height = height
        super.init(frame: .zero)
        
        backgroundColor = UIColor(white: 0.95, alpha: 0.75)
        layer.cornerRadius = height / 2
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: height)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
