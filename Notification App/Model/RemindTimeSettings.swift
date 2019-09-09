//
//  RemindTimeSettings.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 09/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import Foundation

class RemindTimeSetting: Identifiable, ObservableObject {
    var id = UUID()
    @Published var title: String
    
    @Published var remindTimes = [RemindTime]()
    
    init(title: String, seconds: [Int] = [], minutes: [Int] = [], hours: [Int] = [], days: [Int] = [], months: [Int] = [], years: [Int] = []) {
        self.title = title
        
        for second in seconds {
            remindTimes.append(RemindTime(number: second, type: .seconds))
        }
        for minute in minutes {
            remindTimes.append(RemindTime(number: minute, type: .minutes))
        }
        for hour in hours {
            remindTimes.append(RemindTime(number: hour, type: .hours))
        }
        for day in days {
            remindTimes.append(RemindTime(number: day, type: .days))
        }
        for month in months {
            remindTimes.append(RemindTime(number: month, type: .months))
        }
        for year in years {
            remindTimes.append(RemindTime(number: year, type: .years))
        }
    }
}

class RemindTime: Identifiable, ObservableObject {
    var id = UUID()
    
    @Published var number: Int
    @Published var numberStr: String {
        didSet {
            do {
                try updateNumFromString()
            } catch RemindTimeError.numberStringInvalid {
                numberStr = oldValue
            } catch {
                // Unexpected error
            }
        }
    }
    @Published var typeInt: Int {
        didSet {
            if type != TimeTypeInt(rawValue: typeInt)! {
                type = TimeTypeInt(rawValue: typeInt)!
            }
        }
    }
    var type: TimeTypeInt {
        didSet {
            if typeInt != type.rawValue {
                typeInt = type.rawValue
            }
        }
    }
    
    init(number: Int, type: TimeTypeInt) {
        self.number = number
        self.typeInt = type.rawValue
        self.type = type
        self.numberStr = String(number)
    }
    
    func updateNumFromString() throws {
//        guard isValidInteger() else {throw RemindTimeError.numberStringInvalid}
        if !isValidInteger() {
            if isEmpty() {
                number = -1
            } else {
                throw RemindTimeError.numberStringInvalid
            }
        } else {
            number = Int(numberStr)!
        }
    }

    private func isValidInteger() -> Bool {
        return Int(numberStr) != nil
    }
    
    private func isEmpty() -> Bool {
        return numberStr == ""
    }
}

enum RemindTimeError: Error {
    case numberStringInvalid
}

enum TimeTypeInt: Int {
    case seconds, minutes, hours, days, months, years
}

enum TimeTypeStr: String, CaseIterable {
    case seconds, minutes, hours, days, months, years
}
