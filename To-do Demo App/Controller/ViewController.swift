//
//  ViewController.swift
//  To-do Demo App
//
//  Created by Matt Minkevich on 20/01/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dodaj", style: .plain, target: self, action: #selector(handleAddTask))
    }
    
    @objc fileprivate func handleAddTask() {
        let newTaskController = NewTaskController()
        let navController = UINavigationController(rootViewController: newTaskController)
        navController.modalPresentationStyle = .fullScreen
        
        present(navController, animated: true)
    }


}

