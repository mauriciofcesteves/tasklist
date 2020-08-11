//
//  AddTaskViewController.swift
//  TaskList
//
//  Created by Mauricio Esteves on 2020-08-10.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
    
    private let taskSubject = PublishSubject<Task>()
    
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObserver()
    }
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var taskNameTextField: UITextField!
    
    @IBAction func save() {
        
        guard let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex) , let taskName = taskNameTextField.text else {
            return
        }
        
        taskSubject.onNext(Task(title: taskName, priority: priority))
        
        self.dismiss(animated: true, completion: nil)
    }
}
