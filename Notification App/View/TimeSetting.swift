//
//  TimeSetting.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 09/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct TimeSetting: View {
    
    @ObservedObject var timeSetting: RemindTimeSetting
//    @EnvironmentObject var userSettings: UserSettings
//    var index: Int
    
    var makingNewSetting: Bool
    
    var body: some View {
        VStack {
            HStack {
                TextField("Setting name", text: $timeSetting.title)
                    .font(.largeTitle)
                
                Button(action: self.buttonPressed) {
                    if makingNewSetting {
                        Text("Add")
                            .font(.title)
                    } else {
                        Text("Delete")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                    
                }
            }
            
            
            Divider()
            
//            List(timeSetting.remindTimes) { setTime in
//                SetTime(remindTime: setTime)
//                    .clipped()
//            }
            
            ForEach(timeSetting.remindTimes) { setTime in
                SetTime(remindTime: setTime)
                    .clipped()
            }.padding()
            
            if timeSetting.remindTimes.count < 8 {
                Button(action: {
                    self.addTime()
                }) {
                    Text("+")
                        .font(.largeTitle)
                }
            }
        }
        .padding()
    }
    
    func addTime() {
        timeSetting.remindTimes.append(RemindTime(number: 1, type: .days))
    }
    
    func buttonPressed() {
//        MARK: Button Pressed
        if makingNewSetting {
            
        } else {
            
        }
    }
    
    
    
//    func settingIsInvalid() -> Bool {
//        for setTime in timeSetting.remindTimes {
//            if setTime.number > 0 {
//                return false
//            }
//        }
//        return true
//    }
}

struct TimeSetting_Previews: PreviewProvider {
    static var previews: some View {
//        TimeSetting(timeSetting: .constant(RemindTimeSetting(title: "aaa", months: [1,3,4])))
        TimeSetting(timeSetting: RemindTimeSetting(title: "aaa", months: [1,3,4]), makingNewSetting: false)
    }
}
