//
//  ListDetailViewController.swift
//  Expired List
//
//  Created by Jason McCoy on 1/24/17.
//  Copyright © 2016 Jason McCoy. All rights reserved.
//

import UIKit
// protocol for transfering data to the alllistviewcontroller
protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(_controller: ListdetailViewController)
    func listDetailViewController(_ controller: ListdetailViewController, didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListdetailViewController, didFinishEditing checklist: Checklist)
}

class ListdetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    var iconName = "Write"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklist = checklistToEdit{
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
            iconName = checklist.iconName
        }
        iconImageView.image = UIImage(named: iconName)
    }
    
    // Making the textField the firstresponder
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // Selecting the row on the tableView
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    // Making a segueway to the IconPickerViewController
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }

    // Disabling or Enabling the done button, if the user input the text to the textField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    // Picking the icon function for the protocol
    func iconPicker(_picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    // Cancel button, closing the previous view
    @IBAction func cancel(){
        delegate?.listDetailViewControllerDidCancel(_controller: self)
    }
    
    // Button is done checking if the user added or edited the item
    @IBAction func done(){
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!, iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
    
}

