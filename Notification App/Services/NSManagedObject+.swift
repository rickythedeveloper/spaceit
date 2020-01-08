//
//  NSManagedObject+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 15/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
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
