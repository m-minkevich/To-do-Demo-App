//
//  NewTaskViewModel.swift
//  To-do Demo App
//
//  Created by Matt Minkevich on 24/01/2022.
//

import Foundation

class NewTaskViewModel {
    
    var title: String? { didSet { checkValidity() } }
    var category: String? { didSet { checkValidity() } }
    var date: Date? { didSet { checkValidity() } }
    
    var isValidObserver: ((Bool) -> ())?
    
    var isSaved: Bool = false
    var isSavedObserver: ((Bool) -> ())?
    
    fileprivate func checkValidity() {
        let isValid = title?.isEmpty == false && category?.isEmpty == false && date != nil
        isValidObserver?(isValid)
    }
    
}
