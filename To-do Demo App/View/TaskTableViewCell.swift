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
            
            let attributedString = NSMutableAttributedString(string: taskViewModel?.title ?? "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)])
            attributedString.append(NSAttributedString(string: " · \(taskViewModel?.time ?? "")", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
            
            titleLabel.attributedText = attributedString
            categoryLabel.text = taskViewModel?.category
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
        iv.heightAnchor.constraint(equalToConstant: 32).isActive = true
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        let overallStackView = UIStackView(arrangedSubviews: [
            categoryBuble,
            titleLabel
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
