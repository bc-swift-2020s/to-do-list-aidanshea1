//
//  ToDoItems.swift
//  ToDo List
//
//  Created by Aidan Shea on 3/9/20.
//  Copyright © 2020 Aidan Shea. All rights reserved.
//

import Foundation
import UserNotifications

class ToDoItems {
    var itemsArray: [ToDoItem] = []
    
    func loadData(completed: @escaping ()->() ) {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        guard let data = try? Data(contentsOf: documentURL) else {return}
        let jsonDecoder = JSONDecoder()
        do {
            itemsArray = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
        } catch {
            print("😡 ERROR: Could not load data \(error.localizedDescription)")
        }
        completed()
    }
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(itemsArray)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("😡 ERROR: Could not save data \(error.localizedDescription)")
        }
        setNotifications()
    }
    
    func setNotifications() {
        guard itemsArray.count > 0 else {
            return
        }
        // Remove all notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // And let's recreate them with the updated date that we just saved
        for index in 0..<itemsArray.count {
            if itemsArray[index].reminderSet {
                let todoItem = itemsArray[index]
                itemsArray[index].notificationID = LocalNotificationManager.setCalendarNotification(title: todoItem.name, subtitle: "", body: todoItem.notes, badgeNumber: nil, sound: .default, date: todoItem.date)
            }
        }
    }
}
