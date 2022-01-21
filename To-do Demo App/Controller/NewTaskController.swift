//
//  NewTaskController.swift
//  To-do Demo App
//
//  Created by Matt Minkevich on 20/01/2022.
//

import UIKit
import CoreData

class NewTaskController: UITableViewController, DatePickerDelegate, PickerDelegate {
    
    fileprivate var taskTitle: String?
    fileprivate var taskDate: Date?
    fileprivate var taskCategory: String?
    
    fileprivate let categories = ["Zakupy", "Praca", "Inne"]
    
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
        switch indexPath.section {
        case 0:
            let cell = TextFieldTableViewCell(style: .default, reuseIdentifier: nil)
            cell.textField.placeholder = "Obowiązkowe"
            cell.textField.addTarget(self, action: #selector(handleTitleChange), for: .editingChanged)
            return cell
        case 1:
            let cell = DatePickerTextFieldTableViewCell(style: .default, reuseIdentifier: nil)
            cell.backgroundColor = .red
            cell.textField.placeholder = "Obowiązkowe"
            cell.delegate = self
            return cell
        default:
            let cell = PickerTextFieldTableViewCell(style: .default, reuseIdentifier: nil)
            cell.backgroundColor = .green
            cell.textField.placeholder = "Obowiązkowe"
            cell.delegate = self
            cell.items = categories
            return cell
        }
    }
    
    @objc fileprivate func handleTitleChange(textField: UITextField) {
        taskTitle = textField.text
    }
    
    func didSelectDate(_ date: Date) {
        taskDate = date
    }
    
    func didSelectItem(_ item: String) {
        taskCategory = item
    }
    
    @objc fileprivate func handleSave() {
        print("Time to save!")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext) else { return }
        let task = Task(entity: entity, insertInto: managedContext)
        task.title = taskTitle
        task.category = taskCategory
        task.date = taskDate
        
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




