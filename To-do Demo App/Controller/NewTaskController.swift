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
        setupNewTaskViewModelObservers()
    }
    
//    MARK:- Setup Layout
    
    fileprivate func setupNavBar() {
        navigationItem.title = "Nowe zadanie"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
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
    
    fileprivate func setupNewTaskViewModelObservers() {
        newTaskViewModel.isValidObserver = { [weak self] (isValid) in
            self?.navigationItem.rightBarButtonItem?.isEnabled = isValid
            self?.navigationItem.rightBarButtonItem?.customView?.backgroundColor = isValid ? .systemBlue : .lightGray
        }
        newTaskViewModel.isSavedObserver = { [weak self] (isSaved) in
            guard let self = self else { return }
            let indexPath = IndexPath(row: (self.tableView.numberOfRows(inSection: 0) - 1), section: 0)
            guard let cell = self.tableView.cellForRow(at: indexPath) else { return }
            cell.textLabel?.isHidden = false
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.customView?.backgroundColor = .lightGray
        }
    }
    
//    MARK:- Delegate and DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
        case 2:
            let cell = PickerTextFieldTableViewCell(style: .default, reuseIdentifier: nil)
            cell.titleLabel.text = "Kategoria"
            cell.textField.placeholder = "Obowiązkowe"
            cell.delegate = self
            cell.items = categories
            return cell
        default:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.selectionStyle = .none
            cell.textLabel?.text = "Successfully added"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            cell.textLabel?.textColor = .systemGreen
            cell.textLabel?.isHidden = true
            return cell
        }
    }
    
//    MARK:- Handlers and delegate methods
    
    @objc fileprivate func handleTitleChange(textField: UITextField) {
        newTaskViewModel.title = textField.text ?? ""
    }
    
    func didSelectDate(_ date: Date) {
        newTaskViewModel.date = date
    }
    
    func didSelectItem(_ item: String) {
        newTaskViewModel.category = item
    }
    
//    MARK:- Save task
    
    @objc fileprivate func handleSave() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext) else { return }
        let task = Task(entity: entity, insertInto: managedContext)
        task.title = newTaskViewModel.title ?? ""
        task.category = newTaskViewModel.category ?? ""
        task.date = newTaskViewModel.date ?? Date()
        
        do {
            try managedContext.save()

            newTaskViewModel.isSavedObserver?(true)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.dismiss(animated: true) { [weak self] in
                    self?.delegate?.refreshTasks()
                }
            }
        } catch {
            showErrorAlert()
        }
    }
    
//    MARK:- Error handling
    
    fileprivate func showErrorAlert() {
        let alertController = UIAlertController(title: "Nie udało się zapisać", message: nil, preferredStyle: .alert)
        
        alertController.addAction(.init(title: "Ok", style: .cancel))
        alertController.addAction(.init(title: "Powtórz", style: .default, handler: { _ in
            self.handleSave()
        }))
        
        self.present(alertController, animated: true)
    }
    
//    MARK:- Navigation
    
    @objc fileprivate func handleDismiss() {
        dismiss(animated: true)
    }
    
    
}

