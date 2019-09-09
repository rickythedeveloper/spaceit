//
//  UNUserNotificationCenter+.swift
//  Reminder
//
//  Created by Rintaro Kawagishi on 06/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import UserNotifications

extension UNUserNotificationCenter {
    func sendNotification(title: String, body: String?) {
        let id: String
        let content = UNMutableNotificationContent()
        content.title = title
        if let body = body {
            content.body = body
            id = "title: \(title), body: \(body)"
        } else {
            id = "title: \(title)"
        }
        let firstTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: firstTrigger)
        add(request, withCompletionHandler: nil)
    }
}
