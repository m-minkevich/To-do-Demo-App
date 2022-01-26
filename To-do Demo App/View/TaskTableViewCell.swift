//
//  TaskTableViewCell.swift
//  To-do Demo App
//
//  Created by Matt Minkevich on 21/01/2022.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    var taskViewModel: TaskViewModel? {
        didSet {
            categoryBuble.backgroundColor = taskViewModel?.categoryColor
            
            if let image = taskViewModel?.categoryImage {
                categoryImage.isHidden = false
                categoryImage.image = image
            } else {
                categoryImage.isHidden = true
            }
            
            titleLabel.text = taskViewModel?.title
            categoryLabel.text = taskViewModel?.category
            dateLabel.text = taskViewModel?.date
        }
    }
    
    fileprivate let categoryBuble: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGreen
        v.layer.cornerRadius = 16
        v.widthAnchor.constraint(equalToConstant: 72).isActive = true
        v.heightAnchor.constraint(equalToConstant: 72).isActive = true
        return v
    }()
    
    fileprivate let categoryLabel: UILabel = {
        let l = UILabel()
        l.text = "Category"
        l.textColor = .white
        l.font = .systemFont(ofSize: 14, weight: .heavy)
        l.textAlignment = .center
        return l
    }()
    
    fileprivate let categoryImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.heightAnchor.constraint(equalToConstant: 32).isActive = true // 36
        iv.widthAnchor.constraint(equalToConstant: 32).isActive = true
        return iv
    }()
    
    fileprivate let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Title"
        l.numberOfLines = 0
        l.font = .boldSystemFont(ofSize: 17)
        return l
    }()
    
    fileprivate let dateLabel: UILabel = {
        let l = UILabel()
        l.text = "Date"
        l.textAlignment = .right
        l.textColor = .darkGray
        l.font = .italicSystemFont(ofSize: 15)
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        let labelsStackView = UIStackView(arrangedSubviews: [
//            dateLabel,
            titleLabel
//            UIView()
        ])
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 6
        
        

        let overallStackView = UIStackView(arrangedSubviews: [
            categoryBuble,
            labelsStackView
//            titleLabel
        ])
        overallStackView.alignment = .center
        overallStackView.spacing = 16

        contentView.addSubview(overallStackView)
        overallStackView.fillSuperview(padding: .init(top: 12, left: 16, bottom: 12, right: 16))

        let categoryStackView = UIStackView(arrangedSubviews: [categoryImage, categoryLabel])
        categoryStackView.axis = .vertical
        categoryStackView.spacing = 4
        categoryStackView.alignment = .center

        categoryBuble.addSubview(categoryStackView)
        categoryStackView.fillSuperview(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        
        
        let customSeparatorView = UIView()
        customSeparatorView.backgroundColor = .lightGray
        addSubview(customSeparatorView)
        // leftPadding[16] + categoryBubble[72] + overallStackViewSpacing[16]
        customSeparatorView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 104, bottom: 0, right: 0), size: .init(width: 0, height: 0.5))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
