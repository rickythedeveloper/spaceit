//
//  UserSettings.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 09/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import Foundation

class UserSettings: ObservableObject {
    @Published var remindTimeSettings = [RemindTimeSetting(title: "1.1", seconds: [1,10], minutes: [1,30], hours: [1,5]),
                                         RemindTimeSetting(title: "2.1", hours: [1,2], days: [1,7], months: [1]),
                                         RemindTimeSetting(title: "3.1", months: [1,2], years: [1])]
}
