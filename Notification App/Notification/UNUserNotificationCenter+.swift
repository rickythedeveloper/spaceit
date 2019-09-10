//
//  UNUserNotificationCenter+.swift
//  Reminder
//
//  Created by Rintaro Kawagishi on 06/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import UserNotifications

extension UNUserNotificationCenter {
    func sendNotification(requestID: String?, title: String, body: String?, remindTimeSetting: RemindTimeSetting?) {
        var id: String
        let content = UNMutableNotificationContent()
        content.title = title
        if let body = body {
            content.body = body
            id = "title: \(title), body: \(body)"
        } else {
            id = "title: \(title)"
        }
        
        if let requestID = requestID {
            id = requestID
        }
        
        if let remindTimeSetting = remindTimeSetting {
            
            var counter = 0
            for remindTime in remindTimeSetting.remindTimes {
                let number = remindTime.number
                let type = remindTime.typeInt
                
                var factor: Int
                switch type {
                case 0:
                    factor = 1
                case 1:
                    factor = 60
                case 2:
                    factor = 60*60
                case 3:
                    factor = 60*60*24
                case 4:
                    factor = 60*60*24*31
                case 5:
                    factor = 60*60*24*365
                default:
                    factor = 0
                }
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(factor*number), repeats: false)
                let request = UNNotificationRequest(identifier: id + "_" + String(counter), content: content, trigger: trigger)
                add(request, withCompletionHandler: nil)
                
                counter += 1
            }
        } else {
            let firstTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
            let request = UNNotificationRequest(identifier: id, content: content, trigger: firstTrigger)
            add(request, withCompletionHandler: nil)
        }
    }
}
