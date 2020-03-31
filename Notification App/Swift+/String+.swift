//
//  String+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 17/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import Foundation

extension String {
    func hasContent() -> Bool {
        var hasContent = false
        for character in self {
            if !(character == " " || character == "\n" || character == "\t") {
                hasContent = true
                break
            }
        }
        return hasContent
    }
    
    static func time(timeInterval: TimeInterval) -> String {
        if timeInterval < 60*60*24 {
            let hours = Int((timeInterval / (60*60) ).rounded())
            if hours == 0 {
                return "< 30 minutes"
            } else if hours == 1 {
                return "1 hour"
            } else {
                return "\(hours) hours"
            }
        } else {
            let days = Int((timeInterval / (60*60*24)).rounded())
            if days == 1 {
                return "1 day"
            } else {
                return "\(days) days"
            }
        }
    }
}
