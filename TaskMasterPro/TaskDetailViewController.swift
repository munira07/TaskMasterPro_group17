//
//  TaskDetailViewController.swift
//  TaskMasterPro
//
//  Created by Nash  on 2024-03-24.
//

import UIKit

class TaskDetailViewController: UIViewController {

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    var task: Task?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let task = task {
            taskNameLabel.text = task.taskName
            taskDescriptionLabel.text = task.taskDescription
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            
            dueDateLabel.text = task.dueDate != nil ? formatter.string(from: task.dueDate!) : "No Due Date"
        
            priorityLabel.text = task.priority
            statusLabel.text = task.status
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           updateUI()
       }
    
    func updateUI() {
            guard let task = task else { return }

            taskNameLabel.text = task.taskName
            taskDescriptionLabel.text = task.taskDescription
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            dueDateLabel.text = task.dueDate != nil ? formatter.string(from: task.dueDate!) : "No Due Date"
            
            priorityLabel.text = task.priority
            statusLabel.text = task.status
        }
    
    @IBAction func deleteTaskButtonTapped(_ sender: Any) {
        
        presentDeletionConfirmationAlert()
        
    }
    @IBAction func editTaskButtonTapped(_ sender: Any) {
            performSegue(withIdentifier: "editTask", sender: self)
        }
    @IBAction func editTask(_ sender: Any) {
    }
    
    private func presentDeletionConfirmationAlert() {
            let alert = UIAlertController(title: "Delete Task", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                self?.deleteTask()
            }))
            present(alert, animated: true)
        }
        
    private func deleteTask() {
            guard let context = task?.managedObjectContext, let taskToDelete = task else { return }
            
            context.delete(taskToDelete)
            
            do {
                try context.save()
                navigationController?.popViewController(animated: true)
            } catch let error as NSError {
                print("Error deleting task: \(error), \(error.userInfo)")
            }
        }
    @IBAction func deleteTask(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTask", let editVC = segue.destination as? EditTaskViewController {
            editVC.task = self.task
        }
    }

    
}

