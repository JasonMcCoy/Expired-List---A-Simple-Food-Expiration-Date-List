//
//  DataModel.swift
//  Expired List
//
//  Created by Jason McCoy on 1/24/17.
//  Copyright © 2016 Jason McCoy. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    // Setting up or getting the indexOfSelectedList for remembering on what screen user was
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        } set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    // Function returning the unique ID from userDefaults to the new checklistItem
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID+1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
    
    // Setting up the UserDefaults standart values
    func registerDefaults() {
        let dictionary: [String: Any] = ["ChecklistIndex": -1, "FirstTime": true, "ChecklistItemID": 0 ]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    // Function for handling the first time experience
    func handleFirstTime(){
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "My expired food list", iconName: "write")
            
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    // Sorting the checklist items in order of alphabet
    func sortChecklists() {
        lists.sort(by: {checklist1, checklist2 in return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending})
    }
    
    // Creating the directory for the document
    func documentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths [0]
    }
    
    // Creating the directory to the file in the Documents
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    // This method is used for saving
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(lists, forKey:"Checklists")
        archiver.finishEncoding()
        
        data.write(to: dataFilePath(), atomically: true)
    }
    
    // This method is used for loading
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            
            lists = unarchiver.decodeObject(forKey:"Checklists") as! [Checklist]
            unarchiver.finishDecoding()
            sortChecklists()
        }
    }
    // Initalizer of DataModel when the data model is created
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
}
