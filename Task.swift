//
//  Task.swift
//  ToDoList
//
//  Created by Ronak Patel on 3/09/2016.
//  Copyright © 2016 University Of Sydney. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    
    
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    dynamic var notes = ""
    dynamic var isCompleted = false
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
