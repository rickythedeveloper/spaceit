//
//  NSAttributedString+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 30/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension NSAttributedString {
    static func descriptionAttributes(task: TaskSaved) -> [NSAttributedString.Key: Any] {
        var descriptionAttirbutes: [NSAttributedString.Key: Any]
        if !task.isActive {
            descriptionAttirbutes = [.foregroundColor: UIColor.archivedGray().desc, .font: UIFont.preferredFont(forTextStyle: .body)]
        } else if task.isDue() {
            descriptionAttirbutes = [.foregroundColor: UIColor.dueRed().desc, .font: UIFont.preferredFont(forTextStyle: .body)]
        } else {
            descriptionAttirbutes = [.foregroundColor: UIColor.systemGray, .font: UIFont.preferredFont(forTextStyle: .body)]
        }
        
        return descriptionAttirbutes
    }
    
    static func bodyAttributes(task: TaskSaved) -> [NSAttributedString.Key: Any] {
        var bodyAttributes: [NSAttributedString.Key: Any]
        if !task.isActive {
            bodyAttributes = [.foregroundColor: UIColor.archivedGray().body, .font: UIFont.preferredFont(forTextStyle: .body)]
        } else if task.isDue() {
            bodyAttributes = [.foregroundColor: UIColor.dueRed().body, .font: UIFont.preferredFont(forTextStyle: .body)]
        } else {
            bodyAttributes = [.font: UIFont.preferredFont(forTextStyle: .body)]
        }
        return bodyAttributes
    }
}
