//
//  TaskListViewControlller.swift
//  TaskList
//
//  Created by Mauricio Esteves on 2020-08-10.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var filterByPrioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController, let addTaskVC = navC.viewControllers.first as? AddTaskViewController else {
            fatalError("AddTaskViewController not found.")
        }
        
        addTaskVC.taskSubjectObservable.subscribe(onNext: { [unowned self] task in
            
            let priority = Priority(rawValue: self.filterByPrioritySegmentedControl.selectedSegmentIndex - 1)
            
            var existingTasks = self.tasks.value
            existingTasks.append(task)
            self.tasks.accept(existingTasks)
            
            self.filterTasks(by: priority)
            
        }).disposed(by: disposeBag)
    }
    
    private func filterTasks(by priority: Priority?) {
        if priority == nil {
            self.filteredTasks = self.tasks.value
            updateTableView()
        } else {
            self.tasks.map { tasks in
                return tasks.filter({ $0.priority == priority! })
            }.subscribe(onNext: { [weak self] tasks in
                self?.filteredTasks = tasks
                self?.updateTableView()
            }).disposed(by: disposeBag)
        }
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func priorityValueChanged(segmentedControl: UISegmentedControl) {
        
        let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex - 1)
        filterTasks(by: priority)
    }
}

extension TaskListViewController: UITableViewDelegate {
}

extension TaskListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        cell.textLabel?.text = self.filteredTasks[indexPath.row].title
        return cell
    }
    
}
