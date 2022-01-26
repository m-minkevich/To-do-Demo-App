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
    
    fileprivate var groupedTaskViewModels = [[TaskViewModel]]() { didSet { checkNumberOfTaskViewModels() } }
    
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
        let action = UIContextualAction(style: .destructive, title: "Usuń") { (_, _, completion) in
            self.handleDeleteTask(indexPath: indexPath)
            completion(true)
        }
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [action])
        swipeConfig.performsFirstActionWithFullSwipe = false

        return swipeConfig
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
            showErrorAlert()
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
    
    fileprivate func handleDeleteTask(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Na pewno chcesz usunąć?", message: nil, preferredStyle: .alert)
        
        alertController.addAction(.init(title: "Nie, dziękuję", style: .cancel))
        alertController.addAction(.init(title: "Usuń", style: .destructive, handler: { _ in
            self.deleteTask(indexPath: indexPath)
        }))
        
        self.present(alertController, animated: true)
    }
    
    fileprivate func deleteTask(indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        tableView.beginUpdates()
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let task = groupedTaskViewModels[indexPath.section][indexPath.row].task

        managedContext.delete(task)
        groupedTaskViewModels[indexPath.section].remove(at: indexPath.row)
        appDelegate.saveContext()
        
        tableView.deleteRows(at: [indexPath], with: .left)
        tableView.endUpdates()
    }
    
    fileprivate func showErrorAlert() {
        let alertController = UIAlertController(title: "Nie udało się pobrać", message: nil, preferredStyle: .alert)
        
        alertController.addAction(.init(title: "Powtórz", style: .default, handler: { _ in
            self.fetchTasks()
        }))
        
        self.present(alertController, animated: true)
    }


}


