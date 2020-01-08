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
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func tasksFetched() -> [TaskSaved] {
        let fetchRequest = NSFetchRequest<TaskSaved>(entityName: "TaskSaved")
        do {
            return try defaultManagedObjectContext().fetch(fetchRequest)
        } catch {
            return [TaskSaved]()
        }
    }
}
