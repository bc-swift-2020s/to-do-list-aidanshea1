//
//  ToDoItem.swift
//  ToDo List
//
//  Created by Aidan Shea on 2/10/20.
//  Copyright © 2020 Aidan Shea. All rights reserved.
//

import Foundation

struct ToDoItem: Codable {
       var name: String
       var date: Date
       var notes: String
    var reminderSet: Bool
    var notificationID: String?
    var completed: Bool
   }
