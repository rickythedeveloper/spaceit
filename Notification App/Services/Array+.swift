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
