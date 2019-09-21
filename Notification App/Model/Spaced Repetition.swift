//
//  Spaced Repetition.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

class TaskStore: ObservableObject {
    @Published var tasks: [Task]
    
    init(tasks: [Task]) {
        self.tasks = tasks
    }
    
    func dueTasks() -> [Task] {
        var dues = [Task]()
        for task in tasks {
            if task.isDue() {
                dues.append(task)
            }
        }
        return dues
    }
    
    func removeTask(_ task: Task) {
        var index = 0
        for each in self.tasks {
            if each.id == task.id {
                self.tasks.remove(at: index)
                return
            } else {
                index += 1
            }
        }
    }
    
    func findTask(_ task: Task) -> Task? {
        for each in self.tasks {
            if each.id == task.id {
                return each
            }
        }
        return nil
    }
}

class Task: Identifiable {
    var id: UUID
    var question: String
    var answer: String?
    var lastChecked: Date
    var waitTime: TimeInterval
    var colour: Color
    var angle: Angle
    
    init(id: UUID = UUID(), question: String, answer: String?, lastChecked: Date = Date(), waitTime: TimeInterval = 60*60*24, colour: Color = Color.randomVibrantColour(), angle: Angle = Angle(degrees: Double.random(in: -5.0...5.0))) {
        self.id = id
        self.question = question
        self.answer = answer
        self.lastChecked = lastChecked
        self.waitTime = waitTime
        self.colour = colour
        self.angle = angle
    }
    
    func isDue() -> Bool {
        let nextRep = self.lastChecked.addingTimeInterval(self.waitTime)
        if nextRep < Date() {
            return true
        }
        return false
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
    
    func dueDate() -> Date {
        return self.lastChecked.addingTimeInterval(self.waitTime)
    }
    
    func dueDateString() -> String {
        let a = DateFormatter()
        a.dateFormat = "dd/MM/yyyy"
        return a.string(from: self.dueDate())
    }
    
//    func makeTaskSaved(context: NSManagedObjectContext) -> TaskSaved {
//        let taskSaved = TaskSaved(context: context)
//        taskSaved.id = self.id
//        taskSaved.question = self.question
//        taskSaved.answer = self.answer
//        taskSaved.lastChecked = self.lastChecked
//        taskSaved.waitTime = self.waitTime
//        return taskSaved
//    }
}

//public class TaskSaved: NSManagedObject, Identifiable {
//    @NSManaged public var id: UUID
//    @NSManaged public var question: String
//    @NSManaged public var answer: String?
//    @NSManaged public var lastChecked: Date
//    @NSManaged public var waitTime: TimeInterval
//}
//
//extension TaskSaved {
//    static func getAllItems() -> NSFetchRequest<TaskSaved> {
////        let request: NSFetchRequest<TaskSaved> = TaskSaved.fetchRequest() as! NSFetchRequest<TaskSaved>
//        let request = NSFetchRequest<TaskSaved>(entityName: "TaskSaved")
//        let sortDescriptor = NSSortDescriptor(key: "lastChecked", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
//        return request
//    }
//    
//    func convertToTask() -> Task {
//        return Task(id: self.id, question: self.question, answer: self.answer, lastChecked: self.lastChecked, waitTime: self.waitTime)
//    }
//    
//    func dueDate() -> Date {
//        return self.convertToTask().dueDate()
//    }
//    
//    func dueDateString() -> String {
//        return self.convertToTask().dueDateString()
//    }
//}
