//
//  ChecklistItem.swift
///  Expired List
//
//  Created by Jason McCoy on 1/24/17.
//  Copyright © 2016 Jason McCoy. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    
    var dueDate = Date()
    var shouldRemind = false
    var itemID : Int
    
    // Changing the items checked to unchecked if the user tapped the item
    func toggleChecked(){
        checked = !checked
    }
    
    // Scheduling the notification for the item if the user decide to enable notfication
    func scheduleNotification() {
        removeNotification()
        
        if shouldRemind && dueDate > Date() {
        
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = text
            content.sound = UNNotificationSound.default()
            
            let calendar = Calendar(identifier: .gregorian)
            let componets = calendar.dateComponents([.month,.day,.hour,.minute], from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: componets, repeats: false)
            
            let request = UNNotificationRequest(identifier:"\(itemID)",content: content, trigger: trigger)
            
            let centre = UNUserNotificationCenter.current()
            centre.add(request)
            
            print("Scheduled notification \(request) for itemID \(itemID)")
        }
    }
    
    //Removing the notofication
    func removeNotification() {
        let centre = UNUserNotificationCenter.current()
        centre.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
    // Protocol for NSCoding for encoding items
    func encode(with aCoder: NSCoder) {
        // Encoding object to the Plist file
        aCoder.encode(text,forKey:"Text")
        aCoder.encode(checked, forKey: "Checked")
        aCoder.encode(dueDate, forKey: "DueDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
        aCoder.encode(itemID, forKey:"ItemID")
    }
    
    //protocol for NSCoding for decoding items
    required init?(coder aDecoder: NSCoder) {
        //Decoding object from the plist file
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Cheched")
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        
        super.init()
    }

    // Init for protocol, and items
    override init() {
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    // Deleting the notification when the item or list was destroyed. 
    deinit {
        removeNotification()
    }
    
}
