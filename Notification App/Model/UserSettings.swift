//
//  UserSettings.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 09/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import Foundation

class UserSettings: ObservableObject {
    @Published var remindTimeSettings = [RemindTimeSetting(title: "Right Now", seconds: [1]),
                                         RemindTimeSetting(title: "Tomorrow same time", days: [1]),
                                         RemindTimeSetting(title: "Spaced Repetition", days: [1, 2, 4, 8, 16, 32, 64])]
}
