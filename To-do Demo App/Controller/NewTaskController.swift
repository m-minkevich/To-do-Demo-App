//
//  NewTaskController.swift
//  To-do Demo App
//
//  Created by Matt Minkevich on 20/01/2022.
//

import UIKit
import CoreData

protocol RefreshTasksDelegate: class {
    func refreshTasks()
}

class NewTaskController: UITableViewController, DatePickerDelegate, PickerDelegate {
    
    weak var delegate: RefreshTasksDelegate?
    
    fileprivate let newTaskViewModel = NewTaskViewModel()
    
    fileprivate let categories = ["Zakupy", "Praca", "Inne"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupNavButtons()
        setupTableView()
        setupNewTaskViewModelObserver()
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = "Nowe zadanie"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always // ????
    }
    
    fileprivate func setupNavButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Anuluj", style: .done, target: self, action: #selector(handleDismiss))
        
        let saveButton = UIButton(title: "Dodaj", backgroundColor: .lightGray)
        saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    fileprivate func setupTableView() {
        tableView.separatorStyle = .none
    }
    
    fileprivate func setupNewTaskViewModelObserver() {
        newTaskViewModel.isValidObserver = { (isValid) in
            print(isValid)
            self.navigationItem.rightBarButtonItem?.isEnabled = isValid
            self.navigationItem.rightBarButtonItem?.customView?.backgroundColor = isValid ? .systemBlue : .lightGray
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = TextFieldTableViewCell(style: .default, reuseIdentifier: nil)
            cell.titleLabel.text = "Nazwa"
            cell.textField.placeholder = "Obowiązkowe"
            cell.textField.addTarget(self, action: #selector(handleTitleChange), for: .editingChanged)
            return cell
        case 1:
            let cell = DatePickerTextFieldTableViewCell(style: .default, reuseIdentifier: nil)
            cell.titleLabel.text = "Data wykonania"
            cell.textField.placeholder = "Obowiązkowe"
            cell.delegate = self
            return cell
        default:
            let cell = PickerTextFieldTableViewCell(style: .default, reuseIdentifier: nil)
            cell.titleLabel.text = "Kategoria"
            cell.textField.placeholder = "Obowiązkowe"
            cell.delegate = self
            cell.items = categories
            return cell
        }
    }
    
    @objc fileprivate func handleTitleChange(textField: UITextField) {
        newTaskViewModel.title = textField.text ?? ""
    }
    
    func didSelectDate(_ date: Date) {
        newTaskViewModel.date = date
    }
    
    func didSelectItem(_ item: String) {
        newTaskViewModel.category = item
    }
    
    @objc fileprivate func handleSave() {
        print("Time to save!")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext) else { return }
        let task = Task(entity: entity, insertInto: managedContext)
        task.title = newTaskViewModel.title
        task.category = newTaskViewModel.category
        task.date = newTaskViewModel.date
        
        do {
            try managedContext.save()
            print("Successfully saved!")
            dismiss(animated: true) { [weak self] in
                self?.delegate?.refreshTasks()
            }
        } catch {
            // TO-DO: handle error
            print("Failed to save!")
        }
    }
    
    @objc fileprivate func handleDismiss() {
        dismiss(animated: true)
    }
    
    
}

