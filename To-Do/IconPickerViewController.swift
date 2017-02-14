//
//  IconPickerViewController.swift
//  Expired List
//
//  Created by Jason McCoy on 1/24/17.
//  Copyright © 2016 Jason McCoy. All rights reserved.
//

import UIKit
// protocol for transfering the icon to the itemdetailViewController
protocol IconPickerViewControllerDelegate: class {
    func iconPicker (_picker: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    weak var delegate: IconPickerViewControllerDelegate?
    
    // Array with names of all the icons
    let icons = [
        "No Icon",
        "Backpack",
        "Book",
        "Briefcase",
        "Bubble chat",
        "Chef hat",
        "Clock",
        "Cog",
        "Computer imac",
        "Contact book",
        "Content download",
        "Designer cup",
        "Cup",
        "Email",
        "Envelope",
        "Globe",
        "Handbag",
         "Headphone",
         "Heart",
         "Home",
         "iPhone",
         "Image",
         "Location",
         "Notebook",
         "Brush",
         "Shopping cart",
         "Smiley face",
         "Syringe",
         "Teapot",
         "User",
         "Write"]
    
    // Setting up the size of the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    // Making the cells for the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        
        let iconName = icons[indexPath.row]
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named: iconName)
        
        return cell
    }
    
    // Picking up the icon from the table 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(_picker: self, didPick: iconName)
        }
    }
}
