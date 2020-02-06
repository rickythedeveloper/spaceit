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
}
