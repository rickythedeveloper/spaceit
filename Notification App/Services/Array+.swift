//
//  Array+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import Foundation

extension Array {
    mutating func moveItem(fromIndex: Int, toIndex: Int) {
        let element = self.remove(at: fromIndex)
        self.insert(element, at: toIndex)
    }
    
    mutating func moveItemToLast(fromIndex: Int) {
        moveItem(fromIndex: fromIndex, toIndex: self.count-1)
    }
}

extension Array where Element : Page {
    func sortedByName() -> [Page] {
        return self.sorted { (lhs, rhs) -> Bool in
            if lhs.name < rhs.name {
                return true
            } else {
                return false
            }
        }
    }
    
    mutating func sortByName() {
        self.sort { (lhs, rhs) -> Bool in
            if lhs.name < rhs.name {
                return true
            } else {
                return false
            }
        }
    }
}

extension Array where Element: TaskSaved {
    func dueTasks() -> [TaskSaved] {
         var dues = [TaskSaved]()
         for task in self {
             if task.isDue() {
                 dues.append(task)
             }
         }
         return dues
    }
    
    func findTask(_ task: TaskSaved) -> TaskSaved? {
        for each in self {
            if each.id == task.id {
                return each
            }
        }
        return nil
    }
    
    mutating func sortByDueDate() {
        self.sort { (lhs, rhs) -> Bool in
            if lhs.dueDate() < rhs.dueDate() {return true} else {return false}
        }
    }
    
    func sortedByDueDate() -> [TaskSaved] {
        return self.sorted { (lhs, rhs) -> Bool in
            if lhs.dueDate() < rhs.dueDate() {return true} else {return false}
        }
    }
    
    mutating func sortByName() {
        self.sort { (lhs, rhs) -> Bool in
            if lhs.question < rhs.question {
                return true
            } else {
                return false
            }
        }
    }
    
    func sortedByName() -> [TaskSaved] {
        return self.sorted { (lhs, rhs) -> Bool in
            if lhs.question < rhs.question {
                return true
            } else {
                return false
            }
        }
    }
}
