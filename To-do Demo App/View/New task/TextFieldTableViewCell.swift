//
//  TextFieldTableViewCell.swift
//  To-do Demo App
//
//  Created by Matt Minkevich on 20/01/2022.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Title"
        l.font = UIFont.boldSystemFont(ofSize: 18)
        return l
    }()
    
    let textField: CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "Placeholder"
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textField])
        stackView.axis = .vertical
        stackView.spacing = 12
        
        contentView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 12, left: 17, bottom: 12, right: 17))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
