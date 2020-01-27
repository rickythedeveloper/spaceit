//
//  FetchedResults+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 22/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

extension FetchedResults where Result: Page {
    func page(id: UUID) -> Page? {
        let possiblePages = self.filter { (page) -> Bool in
            if page.id == id {return true} else {return false}
            }
        guard possiblePages.count == 1 else {return nil}
        return possiblePages[0]
    }
    
    func childrenOfPage(id: UUID) -> [Page] {
        if let thisPage = self.page(id: id) {
            let children = (thisPage.children?.allObjects as! [Page]).sortedByName()
            return children
        } else {
            return []
        }
    }
    
    func conceptsOfPage(id: UUID) -> [TaskSaved] {
        if let thisPage = self.page(id: id) {
            let concepts = (thisPage.concepts?.allObjects as! [TaskSaved]).sortedByCreationDate(oldFirst: true)
            return concepts
        } else {
            return []
        }
    }
    
    func topPage() -> Page? {
        guard self.count > 0 else {return nil}
        return self[0].topPage()
    }
}

extension FetchedResults where Result: TaskSaved {
    func concept(id: UUID) -> TaskSaved? {
        let possibleConcepts = self.filter { (concept) -> Bool in
            if concept.id == id {return true} else {return false}
        }
        guard possibleConcepts.count == 1 else {return nil}
        return possibleConcepts[0]
    }
    
    func findTask(_ task: TaskSaved) -> TaskSaved? {
        for each in self {
            if each.id == task.id {
                return each
            }
        }
        return nil
    }
    
    func dueTasks() -> [TaskSaved]{
        return self.filter({ (task) -> Bool in
            return task.isDue()
        })
    }
    
    func sortedByName() -> [TaskSaved] {
        return self.sorted { (lhs, rhs) -> Bool in
            return lhs.question.localizedStandardCompare(rhs.question) == .orderedAscending
        }
    }
    
    func sortedByDueDate() -> [TaskSaved] {
        return self.sorted { (lhs, rhs) -> Bool in
            return lhs.dueDate() < rhs.dueDate()
        }
    }
    
    func sortedByCreationDate(newFirst: Bool) -> [TaskSaved] {
        for each in self {
            if each.createdAt == nil {
                each.createdAt = Date()
            }
        }
        
        return self.sorted { (lhs, rhs) -> Bool in
            if lhs.createdAt! > rhs.createdAt! {
                return newFirst
            } else {
                return !newFirst
            }
        }
    }
}
