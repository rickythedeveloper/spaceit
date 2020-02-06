//
//  Array+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import Foundation
import CoreData

extension Array {
    mutating func moveItem(fromIndex: Int, toIndex: Int) {
        let element = self.remove(at: fromIndex)
        self.insert(element, at: toIndex)
    }
    
    mutating func moveItemToLast(fromIndex: Int) {
        moveItem(fromIndex: fromIndex, toIndex: self.count-1)
    }
    
    func elementsFromBeginning(number: Int) -> [Element] {
        guard number >= 0 else {return [Element]()}
        
        var nElements: Int
        if number > self.count {
            nElements = self.count
        } else {
            nElements = number
        }
        
        var array = [Element]()
        array = Array(self.prefix(nElements))
        return array
    }
}

extension Array where Element : Page {
    static func pagesFetched(managedObjectContext: NSManagedObjectContext) -> [Page] {
        let fetchRequest = NSFetchRequest<Page>(entityName: "Page")
        do {
            return try managedObjectContext.fetch(fetchRequest)
        } catch {
            return [Page]()
        }
    }
    
    func sortedByName() -> [Page] {
        return self.sorted { (lhs, rhs) -> Bool in
            return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
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
    
    func topPageHandlingClashes(managedObjectContext: NSManagedObjectContext = NSManagedObjectContext.defaultContext()) -> Page? {
        guard self.count > 0 else {return nil}
        
        var topPages = [Page]()
        for eachPageSaved in self {
            var willAddToTopPages = true
            for eachTopPage in topPages {
                if eachPageSaved.topPage().id == eachTopPage.id {
                    willAddToTopPages = false
                }
            }
            if willAddToTopPages {
                topPages.append(eachPageSaved.topPage())
            }
        }
        
        if topPages.count == 0 {
            fatalError()
        } else if topPages.count == 1 {
            return topPages.first!
        } else {
            let managedObjectContext = managedObjectContext
            let newTopPage = Page.createPageInContext(name: "New workspace (merged)", context: managedObjectContext)
            for eachOldTopPage in topPages {
                newTopPage.addToChildren(eachOldTopPage)
            }
            managedObjectContext.saveContext()
            return newTopPage
        }
    }
}

extension Array where Element: TaskSaved {
    static func tasksFetched(managedObjectContext: NSManagedObjectContext) -> [TaskSaved] {
        let fetchRequest = NSFetchRequest<TaskSaved>(entityName: "TaskSaved")
        do {
            return try managedObjectContext.fetch(fetchRequest)
        } catch {
            return [TaskSaved]()
        }
    }
    
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
            return lhs.dueDate() < rhs.dueDate()
        }
    }
    
    func sortedByDueDate() -> [TaskSaved] {
        return self.sorted { (lhs, rhs) -> Bool in
            return lhs.dueDate() < rhs.dueDate()
        }
    }
    
    mutating func sortByName() {
        self.sort { (lhs, rhs) -> Bool in
            return lhs.question < rhs.question
        }
    }
    
    func sortedByName() -> [TaskSaved] {
        return self.sorted { (lhs, rhs) -> Bool in
            return lhs.question.localizedStandardCompare(rhs.question) == .orderedAscending
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
    
    func orderAccountingForPutOffs(putOffIDs: [UUID]) -> [TaskSaved] {
        var tasks = self
        for putOffID in putOffIDs {
            var index = 0
            for eachTask in tasks {
                if putOffID == eachTask.id {
                    tasks.moveItemToLast(fromIndex: index)
                }
                index += 1
            }
        }
        return tasks
    }
}
