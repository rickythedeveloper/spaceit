//
//  NSManagedObjectContext+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 05/02/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import CoreData
import UIKit

extension NSManagedObjectContext {
    static func defaultContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveContext(completion: @escaping ()->Void = {}, errorHandler: ()->Void = {}, iteration: Int = 0) {
        guard self.hasChanges else {completion(); return}
        do {
            try self.save()
            _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { (timer) in
                completion()
            })
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
            if iteration < 10 {
                self.saveContext(completion: completion, iteration: iteration + 1)
            } else {
                print("Error whilst saving to core data. do some error handling.")
                errorHandler()
            }
        }
    }
}
