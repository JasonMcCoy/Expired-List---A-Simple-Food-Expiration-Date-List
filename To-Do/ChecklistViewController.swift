//
//  ChecklistViewController.swift (ViewController.swift)
//  Expired List
//
//  Created by Jason McCoy on 1/24/17.
//  Copyright © 2016 Jason McCoy. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var checklist: Checklist!
    
    // Added for share
    var item : ChecklistItem?
    
    // @IBOutlet weak var Image: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    // Creating a table with prototip cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let image  = cell.viewWithTag(777) as! UIImageView
        let item = checklist.items[indexPath.row]
        
        
        image.image = #imageLiteral(resourceName: "EmptyBox")
        configurateText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    // Tapping the row in the table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // Swipe to delete method
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    // Making a segue to other pages
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    // Making the configuration of the cell, if user tapped the row and setting the checkbox and it user tapped the row setting the empty box
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        let remindLabel = cell.viewWithTag(101) as! UILabel
        let image = cell.viewWithTag(777) as! UIImageView

        if item.checked{
            image.image = #imageLiteral(resourceName: "CheckedBox")
            label.textColor = view.tintColor
            remindLabel.textColor = view.tintColor
        } else {
            image.image = #imageLiteral(resourceName: "EmptyBox")
            label.textColor = UIColor.black
            remindLabel.textColor = UIColor.black
        }
    }
    
    // Configurating the text for the cell, setting up the reminder
    func configurateText(for cell:UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        let reminderLabel = cell.viewWithTag(101) as! UILabel
        label.text = item.text
        
        if item.shouldRemind {
            //let date = item.dueDate
            //reminderLabel.text = "\(date)"
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            reminderLabel.text = "Reminder: \(formatter.string(from: item.dueDate))"
        } else {
            reminderLabel.text = "Reminder is off"
        }
    }
    
    // If user pressed the cancel button, close the previous view
    func itemDetailViewControllerDidCancel (_controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // If user added the new item adding the new item and closing the view
    func itemDetailViewController(_controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        dismiss(animated: true, completion: nil)
    }
    
    // If the user finished editing the existing item close the previous view and update the item
    func itemDetailViewController(_controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item){
            let indexPath = IndexPath(row:index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configurateText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

