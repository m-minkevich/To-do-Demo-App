//
//  Task+CoreDataClass.swift
//  To-do Demo App
//
//  Created by Matt Minkevich on 20/01/2022.
//
//

import Foundation
import CoreData
import UIKit

@objc(Task)
public class Task: NSManagedObject {

    func toTaskViewModel() -> TaskViewModel {
        var categoryColor: UIColor
        var categoryImage: UIImage?
        switch category {
        case "Zakupy":
            categoryColor = .systemGreen
            categoryImage = UIImage(named: "bag.fill")
        case "Praca":
            categoryColor = .systemBlue
            categoryImage = UIImage(named: "desk.fill")
        default:
            categoryColor = .systemPink
            categoryImage = nil
        }
        
        let formattedDate = date.dateString()
        let formattedTime = date.timeString()
        
        return TaskViewModel(title: title, date: formattedDate, time: formattedTime, category: category, categoryColor: categoryColor, categoryImage: categoryImage, task: self)
    }
    
    
}
