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
    
//    fileprivate var taskViewModels = [TaskViewModel]() { didSet { checkNumberOfTaskViewModels() } }
    
    fileprivate var groupedTaskViewModels = [[TaskViewModel]]() { didSet { checkNumberOfTaskViewModels() } }
    
    fileprivate let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupAddButton()
        setupTableView()
        setupNoTasksLabel()
        fetchTasks()
//        deleteAllData()
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
        let isEmpty = groupedTaskViewModels.count == 0
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedTaskViewModels.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let firstTaskViewModel = groupedTaskViewModels[section].first
        return firstTaskViewModel?.date
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedTaskViewModels[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TaskTableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell.taskViewModel = groupedTaskViewModels[indexPath.section][indexPath.row]
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
            let tasks = try managedContext.fetch(request)
            groupedTaskViewModels = convertToGroupedViewModels(tasks: tasks)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            // TO-DO: handle error
            print("Failed to fetch!")
        }
    }
    
    fileprivate func convertToGroupedViewModels(tasks: [Task]) -> [[TaskViewModel]] {
        let groupedTasks = Dictionary(grouping: tasks) { (element) -> Date in
            return element.date.excludeTime()
        }
        let sortedKeys = groupedTasks.keys.sorted()
        
        var groupedViewModels = [[TaskViewModel]]()
        sortedKeys.forEach { (key) in
            let tasksArray = groupedTasks[key]?.sorted(by: { $0.date < $1.date })
            let taskViewModelsArray = tasksArray?.map({$0.toTaskViewModel()})
            groupedViewModels.append(taskViewModelsArray ?? [])
        }
        return groupedViewModels
    }
    
    fileprivate func deleteTask(indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let task = groupedTaskViewModels[indexPath.section][indexPath.row].task

        managedContext.delete(task)
        groupedTaskViewModels[indexPath.section].remove(at: indexPath.row)
        appDelegate.saveContext()
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
    
    
    func deleteAllData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Task> = Task.fetchRequest()
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.returnsObjectsAsFaults = false
        do {
//            let results = try dataController.viewContext.fetch(fetchRequest)
            let tasks = try managedContext.fetch(request)
            for t in tasks {
//                guard let objectData = t as? NSManagedObject else {continue}
//                dataController.viewContext.delete(objectData)
                managedContext.delete(t)
            }
            appDelegate.saveContext()
        } catch let error {
            print("Detele all data in ... error :", error)
        }
    }
    
    


}


