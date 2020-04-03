//
//  User+CoreDataProperties.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 03/04/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var lastUpdated: Date?
    @NSManaged public var subscriptionExpiryDate: Date?
    @NSManaged public var subscriptionLastVerified: Date?

}
