//
//  EditTaskViewController.swift
//  TaskMasterPro
//
//  Created by Nash  on 2024-03-24.
//

import UIKit
import CoreData

class EditTaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var task: Task?
    
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskDescription: UITextField!
    @IBOutlet weak var priorityPicker: UIPickerView!
    @IBOutlet weak var statusPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var priorities = ["High", "Medium", "Low"]
    var statuses = ["Not Started", "In Progress", "Completed"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priorityPicker.dataSource = self
        priorityPicker.delegate = self
        statusPicker.dataSource = self
        statusPicker.delegate = self
       
        if let task = task {
            taskName.text = task.taskName
            taskDescription.text = task.taskDescription
            datePicker.date = task.dueDate ?? Date()
            
            if let priorityIndex = priorities.firstIndex(of: task.priority ?? "") {
                priorityPicker.selectRow(priorityIndex, inComponent: 0, animated: false)
            }
            
            if let statusIndex = statuses.firstIndex(of: task.status ?? "") {
                statusPicker.selectRow(statusIndex, inComponent: 0, animated: false)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == statusPicker {
            return statuses.count
        } else if pickerView == priorityPicker {
            return priorities.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == statusPicker {
            return statuses[row]
        } else if pickerView == priorityPicker {
            return priorities[row]
        }
        return nil
    }
    
    @IBAction func update(_ sender: Any) {
        guard let taskToUpdate = task, let context = taskToUpdate.managedObjectContext else { return }
        
        taskToUpdate.taskName = taskName.text ?? ""
        taskToUpdate.taskDescription = taskDescription.text ?? ""
        taskToUpdate.dueDate = datePicker.date
        taskToUpdate.priority = priorities[priorityPicker.selectedRow(inComponent: 0)]
        taskToUpdate.status = statuses[statusPicker.selectedRow(inComponent: 0)]
        
        do {
            try context.save()
            print("Task updated successfully")
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to update task: \(error.localizedDescription)")
        }
    }
}
