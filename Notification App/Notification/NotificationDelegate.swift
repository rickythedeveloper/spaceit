//
//  NotificationDelegate.swift
//  Reminder
//
//  Created by Rintaro Kawagishi on 06/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static var shared = NotificationDelegate()
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//         do something if they tap the notification??
        let title = response.notification.request.content.title
        let body = response.notification.request.content.body
        let id = response.notification.request.identifier
        center.sendNotification(requestID: id, title: title, body: body, remindTimeSetting: nil)
        completionHandler()
    }
}
