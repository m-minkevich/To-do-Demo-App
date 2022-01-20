//
//  TextFieldTableViewCell.swift
//  To-do Demo App
//
//  Created by Matt Minkevich on 20/01/2022.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    let textField: CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "Placeholder"
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
