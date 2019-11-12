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
    
    func sortedByCreationDate(oldFirst: Bool) -> [TaskSaved] {
        return self.sorted { (lhs, rhs) -> Bool in
            if lhs.createdAt == nil {
                lhs.createdAt = Date()
            }
            if rhs.createdAt == nil {
                rhs.createdAt = Date()
            }
            
            if oldFirst {
                return lhs.createdAt! < rhs.createdAt!
            } else {
                return rhs.createdAt! < lhs.createdAt!
            }
        }
    }
    
    func activeTasks() -> [TaskSaved] {
        return self.filter { (task) -> Bool in
            task.isActive ? true : false
        }
    }
    
    func filterByWord(searchPhrase: String) -> [TaskSaved] {
        self.filter { (task) -> Bool in
            if task.question.localizedCaseInsensitiveContains(searchPhrase) {return true}
            if let answer = task.answer, answer.localizedCaseInsensitiveContains(searchPhrase) {return true}
            if let page = task.page, page.breadCrumb().localizedCaseInsensitiveContains(searchPhrase) {return true}
            return false
        }
    }
}
