//
//  UNUserNotificationCenter+.swift
//  Reminder
//
//  Created by Rintaro Kawagishi on 06/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import UserNotifications

extension UNUserNotificationCenter {
    
    func sendSRTaskNotification(task: TaskSaved) {
        sendSRTaskNotification(id: task.id, question: task.question, waitTime: task.waitTime)
    }
    
    func sendSRTaskNotification(id: UUID, question: String, waitTime: TimeInterval) {
        sendSRTaskNotification(idString: id.uuidString, question: question, waitTime: waitTime)
    }
    
    func sendSRTaskNotification(idString: String, question: String, waitTime: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Spaced Repetition"
        content.body = question
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: waitTime, repeats: false)
        let request = UNNotificationRequest(identifier: idString, content: content, trigger: trigger)
        add(request) { (error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
    }
    
}

