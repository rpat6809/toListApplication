//
//  TaskList.swift
//  ToDoList
//
//  Created by Ronak Patel on 3/09/2016.
//  Copyright © 2016 University Of Sydney. All rights reserved.
//

import Foundation
import RealmSwift

class TaskList: Object {
    
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    let tasks = List<Task>()

 
    // Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
