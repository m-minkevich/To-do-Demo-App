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
        var categoryImage: UIImage
        switch category {
        case "Zakupy":
            categoryColor = .systemBlue
            categoryImage = UIImage(named: "Desk.fill") ?? UIImage()
        case "Praca":
            categoryColor = .systemGreen
            categoryImage = UIImage(named: "Desk.fill") ?? UIImage()
        default:
            categoryColor = .systemPink
            categoryImage = UIImage(named: "Desk.fill") ?? UIImage()
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
