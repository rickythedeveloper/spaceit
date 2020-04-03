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

extension User {
    /// Fetch and return an array of Users from the Core Data. It will return an empty array if the fetch fails / if there is no object
    private static func fetchUsers(managedObjectContext: NSManagedObjectContext) -> [User] {
        do {
            return try managedObjectContext.fetch(fetchRequest())
        } catch {
            return [User]()
        }
    }
    
    /// Fetch all User objects from Core Data and look through them and return the User object with the latest info. It will return nil if there are no User objects in Core Data or if all the User objects are in invalid forms.
    static func latestUserInfo(managedObjectContext: NSManagedObjectContext) -> User? {
        let users = fetchUsers(managedObjectContext: managedObjectContext)
        guard users.count > 0 else {return nil}
        
        var latestUser: User? = nil
        var unnecessaryUsers = [User]()
        for user in users {
            guard let lastUpdated = user.lastUpdated else {
                unnecessaryUsers.append(user)
                continue
            }
            guard let latest = latestUser?.lastUpdated else {
                latestUser = user
                continue
            }
            
            if latest < lastUpdated {
                latestUser = user
            } else {
                unnecessaryUsers.append(user)
            }
        }
        
        for unnecessaryUser in unnecessaryUsers {
            managedObjectContext.delete(unnecessaryUser)
            managedObjectContext.saveContext()
            print("Deleting an unnecessary user. Last updated: \(String(describing: unnecessaryUser.lastUpdated)), SubExpiry: \(String(describing: unnecessaryUser.subscriptionExpiryDate)), SubLastVerified: \(String(describing: unnecessaryUser.subscriptionLastVerified))")
        }
        
        return latestUser
    }
    
    /// Returns whether the user should have access to the content based on locally stored information in the User object in Core Data.
    static func userShouldProceedToContent(managedObjectContext: NSManagedObjectContext, userInfo: User? = nil) -> Bool {
        var userChecked: User
        if let user = userInfo {
            userChecked = user
        } else if let user = latestUserInfo(managedObjectContext: managedObjectContext) {
            userChecked = user
        } else {
            return false
        }
        
        guard let expiryDate = userChecked.subscriptionExpiryDate, let subLastVerified = userChecked.subscriptionLastVerified else {return false}
        
        if expiryDate < Date() { // the subscription seems to have expired
            if subLastVerified < Date(timeIntervalSinceNow: -60*60*24*30) { // the subscription was not verified in the last 30 days
                return false
            } else { // the subscription might have expired but the subscription was verified in the last 30 days
                return true
            }
        } else { // the subscription seems to be still active
            return true
        }
    }
    
    /// Create a new User object. Save context after this function.
    static func createNewUser(lastUpdated: Date, subscriptionExpiryDate: Date, subscriptionLastVerified: Date, managedObjectContext: NSManagedObjectContext) -> User {
        let user = User(context: managedObjectContext)
        user.lastUpdated = lastUpdated
        user.subscriptionExpiryDate = subscriptionExpiryDate
        user.subscriptionLastVerified = subscriptionLastVerified
        return user
    }
    
    /// Overwrite the user info. Save context after this function.
    func updateInfo(lastUpdated: Date, subscriptionExpiryDate: Date, subscriptionLastVerified: Date) {
        self.lastUpdated = lastUpdated
        self.subscriptionExpiryDate = subscriptionExpiryDate
        self.subscriptionLastVerified = subscriptionLastVerified
    }
}
