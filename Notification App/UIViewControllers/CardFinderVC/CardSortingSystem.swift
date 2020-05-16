//
//  CardSortingSystem.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 16/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import CoreData

enum CardSortingSyetem: String, CaseIterable {
    case dueDate
    case alphabetical
    case creationDate
    
    func cellClass() -> UITableViewCell.Type {
        switch self {
        case .dueDate:
            return UpcomingCardListCell.self
        case .alphabetical:
            return AlphabeticalCardListCell.self
        case .creationDate:
            return CreationDateCardListCell.self
        }
    }
    
    func taskArray(managedObjectContext: NSManagedObjectContext) -> [TaskSaved] {
        let tasks = Array.tasksFetched(managedObjectContext: managedObjectContext)
        switch self {
        case .dueDate:
            return tasks.sortedByDueDate()
        case .alphabetical:
            return tasks.sortedByName()
        case .creationDate:
            return tasks.sortedByCreationDate(oldFirst: false)
        }
    }
    
    func next() -> CardSortingSyetem {
        switch self {
        case .dueDate:
            return .alphabetical
        case .alphabetical:
            return .creationDate
        case .creationDate:
            return .dueDate
        }
    }
}
