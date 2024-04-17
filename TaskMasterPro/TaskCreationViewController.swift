//
//  TaskCreationViewController.swift
//  TaskMasterPro
//
//  Created by Nash  on 2024-02-26.
//
import UIKit
import CoreData

class TaskCreationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var managedObjectContext: NSManagedObjectContext?
    
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskDescription: UITextField!
    @IBOutlet weak var statusPicker: UIPickerView!
    @IBOutlet weak var priorityPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var priorities = ["High", "Medium", "Low"]
    var statuses = ["Not Started", "In Progress", "Completed"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the picker views
        statusPicker.dataSource = self
        statusPicker.delegate = self
        priorityPicker.dataSource = self
        priorityPicker.delegate = self
        
        taskName.delegate = self
        taskDescription.delegate = self
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            managedObjectContext = appDelegate.persistentContainer.viewContext
        }
    }
    
    @IBAction func create(_ sender: Any) {

        guard let taskNameText = taskName.text?.trimmingCharacters(in: .whitespacesAndNewlines), !taskNameText.isEmpty,
              let taskDescriptionText = taskDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines), !taskDescriptionText.isEmpty else {
            
            presentAlertWithTitle(title: "Missing Information", message: "Please enter both a name and a description for the task.", options: "OK") { _ in }
            return
        }
        
        guard let context = managedObjectContext else { return }
        
        let newTask = Task(context: context)
        newTask.taskName = taskNameText
        newTask.taskDescription = taskDescriptionText
        newTask.dueDate = datePicker.date
        
        let selectedStatusIndex = statusPicker.selectedRow(inComponent: 0)
        newTask.status = statuses[selectedStatusIndex]
        
        let selectedPriorityIndex = priorityPicker.selectedRow(inComponent: 0)
        newTask.priority = priorities[selectedPriorityIndex]
        
        do {
            try context.save()
            print("Task saved successfully")
            navigationController?.popViewController(animated: true)
            
        } catch {
            print("Failed to save task: \(error)")
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == taskName || textField == taskDescription {
            textField.text = ""
        }
    }
    
    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
}



