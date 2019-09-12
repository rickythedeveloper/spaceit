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
    
    @EnvironmentObject private var userSettings: UserSettings
    var index: Int
    
    @ObservedObject var thisSetting: RemindTimeSetting
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 8)
    
    @State private var isDeleted =  false
    
    var body: some View {
        GeometryReader { viewGeometry in
            VStack {
                if !self.isDeleted {
                    HStack {
                        TextField("Setting name", text: self.$userSettings.remindTimeSettings[self.index].title)
                            .font(.title)
                        
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
                        ForEach(0..<self.userSettings.remindTimeSettings[self.index].remindTimes.count, id: \.self) { n in
                            SetTime(remindTime: self.userSettings.remindTimeSettings[self.index].remindTimes[n], kGuardian: self.kGuardian, index: n)
                                .background(GeometryGetter(rect: self.$kGuardian.rects[n]))
                        }
                        
                        if self.userSettings.remindTimeSettings[self.index].remindTimes.count < 8 {
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.addTime()
                                }) {
                                    Image(systemName: "plus")
                                        .imageScale(.large)
                                }
                                Spacer()
                            }
                        }
                    }.offset(y: self.kGuardian.slide).animation(.easeInOut(duration: 0.2))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                UIApplication.shared.endEditing()
                            }
                    )
                    
//                    Spacer()
                }
            }.navigationBarTitle("Details")
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
        TimeSetting(index: 0, thisSetting: RemindTimeSetting(title: "aaa", seconds: [1111])).environmentObject(UserSettings())
    }
}
