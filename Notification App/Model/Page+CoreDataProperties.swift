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
        
        if let parent = self.parent, parent.parent != nil { // if the page has two layers above, continue adding. If it just has the top page as a parent, then just return the current breadcrumbs since the top page is obvious.
            return parent.breadCrumbAlgorithm(bc: thisPageName)
        } else {
            return thisPageName
        }
    }
    
    func topPage() -> Page {
        if let parent = self.parent {
            return parent.topPage()
        } else {
            return self
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

extension Page {
    func nOfConceptsUnder() -> Int {
        return self.countConceptsInChildren(alreadyCounted: 0)
    }
    
    func countConceptsInChildren(alreadyCounted: Int) -> Int {
        var count = alreadyCounted
        if self.concepts != nil {
            count += self.concepts!.count
        }
        if self.children != nil {
            var countFromKids = 0
            for child in self.children! as! Set<Page> {
                countFromKids += child.countConceptsInChildren(alreadyCounted: 0)
            }
            return count + countFromKids
        }
        return count
    }
    
    func nOfDueConcepts() -> Int {
        return self.conceptsUnderThisPage().dueTasks().activeTasks().count
    }
    
    func conceptsUnderThisPage() -> [TaskSaved] {
        return self.conceptsInChildren(alreadyAdded: [TaskSaved]())
    }
    
    func conceptsInChildren(alreadyAdded: [TaskSaved]) -> [TaskSaved] {
        var addedConcepts = alreadyAdded
        
        if self.concepts != nil {
            for concept in self.concepts! as! Set<TaskSaved> {
                addedConcepts.append(concept)
            }
        }
        
        if self.children != nil {
            var conceptsFromKids = [TaskSaved]()
            for child in self.children! as! Set<Page> {
                for eachConcept in child.conceptsInChildren(alreadyAdded: [TaskSaved]()) {
                    conceptsFromKids.append(eachConcept)
                }
            }
            
            for eachConceptFromKid in conceptsFromKids {
                addedConcepts.append(eachConceptFromKid)
            }
            return addedConcepts
        }
        
        return addedConcepts
    }
    
    func childrenArray() -> [Page] {
        return (self.children?.allObjects as! [Page]).sortedByName()
    }
    
    func numberOfChildren() -> Int {
        return childrenArray().count
    }
    
    func cardsArray() -> [TaskSaved] {
        return (self.concepts?.allObjects as! [TaskSaved]).sortedByCreationDate(oldFirst: true)
    }
    
    func numberOfCards() -> Int {
        return cardsArray().count
    }
}
