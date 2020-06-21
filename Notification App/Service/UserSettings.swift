//
//  UserSettings.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 20/06/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import Foundation

class UserSettings {
    
    static let isProUserKey = "isProUser"
    static var isProUser: Bool {
        // DEBUG
        return true
        
        // PRODUCTION
//        let defaults = UserDefaults.standard
//        if defaults.bool(forKey: isProUserKey) == true {
//            return true
//        } else {
//            return false
//        }
    }
    
    static func setUserAccess(isPro: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(isPro, forKey: isProUserKey)
    }
}
