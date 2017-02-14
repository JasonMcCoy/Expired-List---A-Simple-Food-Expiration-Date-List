//
//  AllListsTableViewController.swift
//  Expired List
//
//  Created by Jason McCoy on 1/24/17.
//  Copyright © 2016 Jason McCoy. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        // Checking if their are lists and going to the list where the user was before after opening the app
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    // Reloading the table after opening allList viewController
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    // When user goes to the main screen putting "-1" to the defolts
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print("willShow")
        // Check to see if the user pressed the back button
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // Setting up the size of table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    // Performing segue when touching the row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    // Adding prepare for segue for sending the Checklist object
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist"{
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ListdetailViewController
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }
    
    // Deleting the row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    // Another way to transfer to a different View Without using a segue method from story board if the user tapped the accessoryButton
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        
        let controller = navigationController.topViewController as! ListdetailViewController
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        present(navigationController,animated: true, completion: nil)
        
    }

    // Other way to create a cell without a prototipe cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.font = UIFont.systemFont(ofSize: 19)
        //boldSystemFont(ofSize: 19)
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0{
            cell.detailTextLabel!.text = "No foods in the list 😕"
        } else if count == 0 {
            cell.detailTextLabel!.text = "All your foods are 👌"
        } else {
            cell.detailTextLabel!.text = "\(checklist.countUncheckedItems()) food(s) remaining"
        }
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailButton
        cell.imageView!.image = UIImage(named: checklist.iconName)
        
        return cell
    }
    // Still another way for creating a new cell
    func makeCell (for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    
    // Setting the height of the rows
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // Declaring methods from the delegate 
    func listDetailViewControllerDidCancel(_controller: ListdetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Function for the protocol
    func listDetailViewController(_ controller: ListdetailViewController, didFinishAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    // Function for the protocol 
    func listDetailViewController(_ controller: ListdetailViewController, didFinishEditing checklist: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    
}
