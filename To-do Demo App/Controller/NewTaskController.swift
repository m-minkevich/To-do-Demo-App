//
//  NewTaskController.swift
//  To-do Demo App
//
//  Created by Matt Minkevich on 20/01/2022.
//

import UIKit
import CoreData

class NewTaskController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .yellow
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Anuluj", style: .done, target: self, action: #selector(handleDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Zapisz", style: .plain, target: self, action: #selector(handleSave))
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let l = UILabel()
        switch section {
        case 0:
            l.text = "Nazwa"
        case 1:
            l.text = "Data wykonania"
        default:
            l.text = "Kategoria"
        }
        return l
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TextFieldTableViewCell(style: .default, reuseIdentifier: nil)
        cell.textField.placeholder = "Obowiązkowe"
        return cell
    }
    
    @objc fileprivate func handleSave() {
        print("Time to save!")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext) else { return }
        let task = Task(entity: entity, insertInto: managedContext)
        task.title = "Modified title"
//        let task = NSManagedObject(entity: entity, insertInto: managedContext)
//        task.setValue("New sample task", forKey: "title")
        
        do {
            try managedContext.save()
            print("Successfully saved!")
        } catch {
            // TO-DO: handle error
            print("Failed to save!")
        }
    }
    
    @objc fileprivate func handleDismiss() {
        dismiss(animated: true)
    }
    
}
