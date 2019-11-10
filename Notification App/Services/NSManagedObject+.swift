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
    func saveContext(completion: @escaping ()->Void = {}) {
        do {
            try self.save()
            _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { (timer) in
                completion()
            })
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
            self.saveContext(completion: completion)
        }
    }
}
