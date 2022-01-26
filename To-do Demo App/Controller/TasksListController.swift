//
//  TasksListController.swift
//  To-do Demo App
//
//  Created by Matt Minkevich on 20/01/2022.
//

import UIKit
import CoreData

class TasksListController: UIViewController, UITableViewDelegate, UITableViewDataSource, RefreshTasksDelegate {
    
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped)
    
    fileprivate var taskViewModels = [TaskViewModel]() { didSet { checkNumberOfTaskViewModels() } }
    
    fileprivate let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupAddButton()
        setupTableView()
        setupNoTasksLabel()
        fetchTasks()
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = "Twoje zadania"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always // ????
    }
    
    fileprivate func setupAddButton() {
        let saveButton = UIButton(title: "Dodaj")
        saveButton.addTarget(self, action: #selector(handleAddTask), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }
    
    fileprivate let noTasksLabel = UILabel()
    
    fileprivate func setupNoTasksLabel() {
        noTasksLabel.text = "Nie masz jeszcze żadnego zadania.\nMasz łatwe życie! :)"
        noTasksLabel.numberOfLines = 0
        noTasksLabel.textAlignment = .center
        noTasksLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        view.addSubview(noTasksLabel)
        noTasksLabel.centerInSuperview()
    }
    
    fileprivate func checkNumberOfTaskViewModels() {
        let isEmpty = taskViewModels.count == 0
        noTasksLabel.isHidden = !isEmpty
        tableView.isScrollEnabled = !isEmpty
    }
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.insetsContentViewsToSafeArea = true
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc fileprivate func handleAddTask() {
        let newTaskController = NewTaskController()
        newTaskController.delegate = self
        let navController = UINavigationController(rootViewController: newTaskController)
        navController.modalPresentationStyle = .fullScreen
        
        present(navController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TaskTableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell.taskViewModel = taskViewModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Usuń") {  [weak self] (contextualAction, view, boolValue) in
            self?.deleteTask(indexPath: indexPath)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
    
    func refreshTasks() {
        fetchTasks()
    }
    
    fileprivate func fetchTasks() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            taskViewModels = try managedContext.fetch(request).map({ $0.toTaskViewModel() })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            // TO-DO: handle error
            print("Failed to fetch!")
        }
    }
    
    fileprivate func deleteTask(indexPath: IndexPath) {
        print("Delete at: ", indexPath)
//        Delete by id???
////        let task = tasks[indexPath.row]
//        let taskViewModel = taskViewModels[indexPath.row]
//
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        managedContext.delete(taskViewModel)
//        taskViewModels.remove(at: indexPath.row)
//        appDelegate.saveContext()
//
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
        
        taskViewModels.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }


}

