//
//  Page+CoreDataProperties.swift
//  
//
//  Created by Rintaro Kawagishi on 21/09/2019.
//
//

import Foundation
import CoreData


extension Page {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Page> {
        let request = NSFetchRequest<Page>(entityName: "Page")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
//    @nonobjc public class func fetchRequest(pageID: UUID) -> NSFetchRequest<Page> {
//        let request = NSFetchRequest<Page>(entityName: "Page")
//        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
//        request.predicate = NSPredicate(format: "id = %@", pageID as CVarArg)
//        return request
//    }
    
    static func createPageInContext(name: String, id: UUID, context: NSManagedObjectContext) -> Page {
        let page = Page(context: context)
        page.name = name
        page.id = id
        return page
    }
    
    func breadCrumb() -> String {
        return self.breadCrumbAlgorithm(bc: "")
    }
    
    private func breadCrumbAlgorithm(bc: String) -> String {
        var thisPageName = self.name
        thisPageName = thisPageName + "/" + bc
        
        if let parent = self.parent {
            return parent.breadCrumbAlgorithm(bc: thisPageName)
        } else {
            return thisPageName
        }
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var children: NSSet?
    @NSManaged public var concepts: NSSet?
    @NSManaged public var parent: Page?

}

// MARK: Generated accessors for children
extension Page {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: Page)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: Page)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)

}

// MARK: Generated accessors for concepts
extension Page {

    @objc(addConceptsObject:)
    @NSManaged public func addToConcepts(_ value: TaskSaved)

    @objc(removeConceptsObject:)
    @NSManaged public func removeFromConcepts(_ value: TaskSaved)

    @objc(addConcepts:)
    @NSManaged public func addToConcepts(_ values: NSSet)

    @objc(removeConcepts:)
    @NSManaged public func removeFromConcepts(_ values: NSSet)

}
