//
//  Task+CoreDataProperties.swift
//  To-do Demo App
//
//  Created by Matt Minkevich on 20/01/2022.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var title: String //?
    @NSManaged public var date: Date //?
    @NSManaged public var category: String //?

}

extension Task : Identifiable {

}
