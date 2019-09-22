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
            let concepts = (thisPage.concepts?.allObjects as! [TaskSaved]).sortedByName()
            return concepts
        } else {
            return []
        }
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
}
