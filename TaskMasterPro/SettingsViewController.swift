//
//  SettingsViewController.swift
//  TaskMasterPro
//
//  Created by Zoe Detlefsen on 2024-03-22.
//

import UIKit
import UserNotifications



class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notficationsSwitch.isOn = false
        darkModeSwitch.isOn = false
        
        let savedName = UserDefaults.standard.string(forKey: "userName")
        
        nameTextField.text = savedName
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var notficationsSwitch: UISwitch!
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    

    @IBAction func darkModeSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            overrideUserInterfaceStyle = .dark
            UserDefaults.standard.set(true, forKey: "darkModeEnabled")
        } else {
            overrideUserInterfaceStyle = .light
            UserDefaults.standard.set(false, forKey: "darkModeEnabled")
        }
    }
    
    @IBAction func notificationsSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            requestNotificationsPermission()
        } else {
            UserDefaults.standard.set(false, forKey: "notificationsEnabled")
        }
    }
    
    @IBAction func saveChangesTapped(_ sender: UIButton) {
        saveSettings()
    }

    @IBAction func nameEditingDidEnd(_ sender: UITextField) {
        
        if let name = sender.text {
            UserDefaults.standard.set(name, forKey: "userName")
        }
    }
    
    private func saveSettings() {
        let defaults = UserDefaults.standard
        defaults.set(nameTextField.text, forKey: "userName")
        defaults.set(notficationsSwitch.isOn, forKey: "enabledNotifications")
        defaults.set(darkModeSwitch.isOn, forKey: "darkModeEnabled")
        
        let alert = UIAlertController(title: "Saved", message: "Your Settings have been saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func requestNotificationsPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in DispatchQueue.main.async {
            if granted {
                UserDefaults.standard.set(true, forKey: "notificationsEnabled")
            } else {
                self.notficationsSwitch.setOn(false, animated:true)
                UserDefaults.standard.set(false, forKey: "notificationsEnabled")
            }
        } }
    }
    
}
