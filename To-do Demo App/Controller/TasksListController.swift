//
//  TasksListController.swift
//  To-do Demo App
//
//  Created by Matt Minkevich on 20/01/2022.
//

import UIKit
import CoreData

class TasksListController: UITableViewController, RefreshTasksDelegate {
    
    fileprivate var taskViewModels = [TaskViewModel]()
    
    fileprivate let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dodaj", style: .plain, target: self, action: #selector(handleAddTask))
        
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: cellId)
        
        fetchTasks()
    }
    
    @objc fileprivate func handleAddTask() {
        let newTaskController = NewTaskController()
        newTaskController.delegate = self
        let navController = UINavigationController(rootViewController: newTaskController)
        navController.modalPresentationStyle = .fullScreen
        
        present(navController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TaskTableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell.taskViewModel = taskViewModels[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
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

