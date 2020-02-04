//
//  UIViewController+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 08/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
    func defaultManagedObjectContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func tasksFetched(managedObjectContext: NSManagedObjectContext) -> [TaskSaved] {
        let fetchRequest = NSFetchRequest<TaskSaved>(entityName: "TaskSaved")
        do {
            return try managedObjectContext.fetch(fetchRequest)
        } catch {
            return [TaskSaved]()
        }
    }
    
    func pagesFetched(managedObjectContext: NSManagedObjectContext) -> [Page] {
        let fetchRequest = NSFetchRequest<Page>(entityName: "Page")
        do {
            return try managedObjectContext.fetch(fetchRequest)
        } catch {
            return [Page]()
        }
    }
}
