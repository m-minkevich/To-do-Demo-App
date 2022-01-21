//
//  TasksListController.swift
//  To-do Demo App
//
//  Created by Matt Minkevich on 20/01/2022.
//

import UIKit
import CoreData

class TasksListController: UITableViewController {
    
    fileprivate var tasks = [Task]()
    
    fileprivate let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dodaj", style: .plain, target: self, action: #selector(handleAddTask))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        fetchTasks()
    }
    
    @objc fileprivate func handleAddTask() {
        let newTaskController = NewTaskController()
        let navController = UINavigationController(rootViewController: newTaskController)
        navController.modalPresentationStyle = .fullScreen
        
        present(navController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = tasks[indexPath.row].title
        cell.detailTextLabel?.text = "\(tasks[indexPath.row].category) - \(tasks[indexPath.row].date)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deleteTask(indexPath: indexPath)
    }
    
    fileprivate func fetchTasks() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            tasks = try managedContext.fetch(request)
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
        let task = tasks[indexPath.row]
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(task)
        tasks.remove(at: indexPath.row)
        appDelegate.saveContext()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }


}

