//
//  ItemDetailViewController.swift
//  Expired List
//
//  Created by Jason McCoy on 1/24/17.
//  Copyright © 2016 Jason McCoy. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

// Protocol for transfering the data to the ChecklistViewController
protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_controller: ItemDetailViewController)
    func itemDetailViewController(_controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    // Declaring the delegate
    weak var delegate: ItemDetailViewControllerDelegate?
    // Variable for inserted data which is passed from ChecklistView Controller for editing
    var itemToEdit: ChecklistItem?
    var dueDate = Date()
    var datePickerVisible = false
    
    
    // Cancel button
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(_controller: self)
    }
    
    // Done button
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            
            item.scheduleNotification()
            
            delegate?.itemDetailViewController(_controller: self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            
            item.scheduleNotification()
            
            delegate?.itemDetailViewController(_controller: self, didFinishAdding: item)
        }
    }
    
    // Change dueDate
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    // If UISwitch was toggled or not
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        textField.resignFirstResponder()
        
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert,.sound]){
                granted, error in /* do nothing */
            }
        }
        
    }
    
    // Outlet for the UI elements
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Unwraping the item to find out if the user adding new item of just editing the item
        if let item = itemToEdit{
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDueDateLabel()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    // Function for displaying the number of row in section if the date picker visible or not overriding the standat fucntion
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    //Setting up height for the DatePicked when he will be called
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    // Calling the date Picked whe he was tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    // Making the datePaicked tappable
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    // Providing newIndexPath if the datepicker becoming visible 
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2{
            newIndexPath = IndexPath(row:0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    // Making the textField the fisrt responder
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // Hiding the datePicker if user started editing the textField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    //Showing the date Picker if user pressed the datePicekr
    func showDatePicker() {
        datePickerVisible = true
        
        let indexPathDateRow = IndexPath(row:1, section:1)
        let indexPathDatePicker = IndexPath(row:2, section: 1)
        
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        //Updating the table
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        
        datePicker.setDate(dueDate, animated: false)
    }
    
    // Hiding the daate picker
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            
            let indexPathDateRow = IndexPath(row:1, section: 1)
            let indexPathDatePicker = IndexPath(row:2, section: 1)
            
            if let cell = tableView.cellForRow(at: indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white:0, alpha: 0.5)
            }
            // Updating the table
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }
    
    // Checking if the user made an imput to the textField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButton.isEnabled = (newText.length > 0)
        
        return true
    }
    
    // Updating the DueDateLabel to display date of the reminder
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
}
