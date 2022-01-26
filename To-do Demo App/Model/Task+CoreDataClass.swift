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
        
        let formattedDate = formatDate(date: date ?? Date())
        
        return TaskViewModel(title: title ?? "", date: formattedDate, category: category ?? "", categoryColor: categoryColor, categoryImage: categoryImage)
    }
    
    fileprivate func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy (HH:mm)"
        return dateFormatter.string(from: date)
    }
    
}
