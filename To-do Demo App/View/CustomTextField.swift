//
//  CustomTextField.swift
//  To-do Demo App
//
//  Created by Matt Minkevich on 20/01/2022.
//

import UIKit

class CustomTextField: UITextField {
   
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
    
    
}
