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
    @NSManaged public var isActive: Bool
    @NSManaged public var createdAt: Date?

}

extension TaskSaved {
//    static func getAllItems() -> NSFetchRequest<TaskSaved> {
////        let request: NSFetchRequest<TaskSaved> = TaskSaved.fetchRequest() as! NSFetchRequest<TaskSaved>
//        let request = NSFetchRequest<TaskSaved>(entityName: "TaskSaved")
//        let sortDescriptor = NSSortDescriptor(key: "lastChecked", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
//        return request
//    }
    
    
    func dueDate() -> Date {
        return self.lastChecked.addingTimeInterval(self.waitTime)
    }
    
    func dueDateStringShort() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: self.dueDate())
    }
    
    func isDue() -> Bool {
        if self.dueDate() < Date() {return true} else {return false}
    }
       
    func prepareForNext(difficulty: Double) {
       guard difficulty >= 0 && difficulty <= 1 else { fatalError("The difficulty is not between 0 and 1") }

       let actualWaitTime = Date().timeIntervalSince(self.lastChecked)
       lastChecked = Date()
       print("this actual wait time: \(actualWaitTime)")
       let minimumFactor = (105 * 60*60*24) / (actualWaitTime + (150 * 60*60*24))
       
       let factor = minimumFactor * pow(5, (1 - difficulty))
       self.waitTime = factor * actualWaitTime
       print("next wait time: \(self.waitTime)")
    }
    
    func creationDateString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        if let createdAt = self.createdAt {
            return dateFormatter.string(from: createdAt)
        } else {
            return nil
        }
    }
}
