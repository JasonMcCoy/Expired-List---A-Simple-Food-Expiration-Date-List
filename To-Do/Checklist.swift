//
//  Checklist.swift
//  Expired List
//
//  Created by Jason McCoy on 1/24/17.
//  Copyright © 2016 Jason McCoy. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    var name = ""
    var items = [ChecklistItem]()
    var iconName : String
    
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    // Initializer for the Checklist item
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    // Function for decoding the items for plists
    required init?(coder aDecoder:NSCoder){
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
        super.init()
    }
    
    // Function for the encoding items from the plists
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name,forKey:"Name")
        aCoder.encode(items, forKey:"Items")
        aCoder.encode(iconName,forKey: "IconName")
    }
    
    // Counting the number of cheked items
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
}
