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
    
    
    /// This function calculates the next wait time for this task and updates the information. Call this function when the task has just been reviewd by the user. Do not forget to save the core data context after this.
    /// - Parameter ease: Ease of the task on a scale of 1 to 4, with 1 being very hard and 4 being very easy.
    func reviewed(ease: Int) {
        self.waitTime = nextWaitTime(ease: ease) // changes the wait time based on the last checked date and current time.
        lastChecked = Date()
    }
    
    /// This function returns  the next wait time for this task.
    /// - Parameter ease: Ease of the task on a scale of 1 to 4, with 1 being very hard and 4 being very easy.
    func nextWaitTime(ease: Int) -> TimeInterval {
        let actualWaitTime = Date().timeIntervalSince(self.lastChecked)
        let actualWaitDays = actualWaitTime / (60*60*24)
        
        var nextWaitDays: Double
        switch ease {
        case 1:
            nextWaitDays = 10 - 10 * exp(-actualWaitDays/10.0)
            break
        case 2:
            nextWaitDays = 30 - 28 * exp(-actualWaitDays/28.0)
            break
        case 3:
            nextWaitDays = actualWaitDays * (1.1 + 3.9 * exp(-actualWaitDays/9.0)) + 2
            break
        case 4:
            nextWaitDays = actualWaitDays * (1.5 + 8.5 * exp(-actualWaitDays/10.0)) + 2
            break
        default:
            fatalError("The ease is out of the valid range")
        }
        
        let nextWaitTime = nextWaitDays * (60*60*24)
        return nextWaitTime
    }
    
    /// Returns the current wait time in a convenient string format.
    func waitTimeString() -> String {
        return String.time(timeInterval: self.waitTime)
    }
}
