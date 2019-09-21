//
//  TaskSaved+CoreDataProperties.swift
//  
//
//  Created by Rintaro Kawagishi on 21/09/2019.
//
//

import Foundation
import CoreData


extension TaskSaved: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskSaved> {
        let request = NSFetchRequest<TaskSaved>(entityName: "TaskSaved")
        let sortDescriptor = NSSortDescriptor(key: "lastChecked", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }

    @NSManaged public var answer: String?
    @NSManaged public var id: UUID
    @NSManaged public var lastChecked: Date
    @NSManaged public var question: String
    @NSManaged public var waitTime: Double
    @NSManaged public var page: Page?

}

extension TaskSaved {
//    static func getAllItems() -> NSFetchRequest<TaskSaved> {
////        let request: NSFetchRequest<TaskSaved> = TaskSaved.fetchRequest() as! NSFetchRequest<TaskSaved>
//        let request = NSFetchRequest<TaskSaved>(entityName: "TaskSaved")
//        let sortDescriptor = NSSortDescriptor(key: "lastChecked", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
//        return request
//    }
    
    func convertToTask() -> Task {
        return Task(id: self.id, question: self.question, answer: self.answer, lastChecked: self.lastChecked, waitTime: self.waitTime)
    }
    
    func dueDate() -> Date {
        return self.convertToTask().dueDate()
    }
    
    func dueDateString() -> String {
        return self.convertToTask().dueDateString()
    }
}
