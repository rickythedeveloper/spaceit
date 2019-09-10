//
//  TimeSetting.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 09/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct TimeSetting: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject var userSettings: UserSettings
    var index: Int
    
    @State var isDeleted =  false
    
    var body: some View {
        GeometryReader { viewGeometry in
            VStack {
                if !self.isDeleted {
                    HStack {
                        TextField("Setting name", text: self.$userSettings.remindTimeSettings[self.index].title)
                            .font(.largeTitle)
                        
                        Button(action: self.buttonPressed) {
                            Text("Delete")
                                .font(.title)
                                .foregroundColor(.red)
                        }
                    }
                    
                    
                    Divider()
                    
//                    List(timeSetting.remindTimes) { setTime in
//                        SetTime(remindTime: setTime)
//                            .clipped()
//                    }
//
//                    ForEach(userSettings.remindTimeSettings[index].remindTimes) { setTime in
//                        SetTime(remindTime: setTime)
//                            .clipped()
//                    }.padding()
                    
                    Form {
                        ForEach(self.userSettings.remindTimeSettings[self.index].remindTimes) { setTime in
                            SetTime(remindTime: setTime)
                        }
                    }
                    
                    if self.userSettings.remindTimeSettings[self.index].remindTimes.count < 8 {
                        Button(action: {
                            self.addTime()
                        }) {
                            Text("+")
                                .font(.largeTitle)
                        }
                    }
                    Spacer()
                }
            }
            .padding()
        }
    }
    
    func addTime() {
        userSettings.remindTimeSettings[index].remindTimes.append(RemindTime(number: 1, type: .days))
    }
    
    func buttonPressed() {
        presentationMode.wrappedValue.dismiss()
        isDeleted = true
        userSettings.remindTimeSettings.remove(at: index)
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
        TimeSetting(index: 0).environmentObject(UserSettings())
    }
}
