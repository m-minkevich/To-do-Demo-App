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
            
            titleLabel.text = taskViewModel?.title
            categoryLabel.text = taskViewModel?.category
            dateLabel.text = taskViewModel?.date
        }
    }
    
    fileprivate let categoryBuble: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGreen
        v.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return v
    }()
    
    fileprivate let categoryLabel: UILabel = {
        let l = UILabel()
        l.text = "Category"
        l.font = .boldSystemFont(ofSize: 15)
        l.textAlignment = .center
        return l
    }()
    
    fileprivate let categoryImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "Shop"))
        iv.contentMode = .scaleAspectFit
        iv.heightAnchor.constraint(equalToConstant: 42).isActive = true
        return iv
    }()
    
    fileprivate let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "TITLE"
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
        backgroundColor = .systemOrange
        
        let labelsStackView = UIStackView(arrangedSubviews: [
            dateLabel,
            titleLabel
        ])
        labelsStackView.axis = .vertical
        
        let overallStackView = UIStackView(arrangedSubviews: [categoryBuble, labelsStackView])
        overallStackView.alignment = .center
        overallStackView.spacing = 4
        
        addSubview(overallStackView)
        overallStackView.fillSuperview()
        
        let categoryStackView = UIStackView(arrangedSubviews: [categoryImage, categoryLabel])
        categoryStackView.axis = .vertical
        categoryStackView.spacing = 4
        
        categoryBuble.addSubview(categoryStackView)
        categoryStackView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
