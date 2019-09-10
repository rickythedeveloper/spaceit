//
//  TimeSettings.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 09/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct TimeSettings: View {
    
    var timeSettings: [RemindTimeSetting]
    
    @State var makingNewSetting = false
    
    var body: some View {
        
        NavigationView {
            List(timeSettings) { timeSetting in
                NavigationLink(destination: TimeSetting(timeSetting: timeSetting, makingNewSetting: false)) {
                    Text(timeSetting.title)
                }
            }
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.makingNewSetting = true
            }) {
                Text("+")
                    .foregroundColor(.blue)
                    .font(.largeTitle)
            })
        }
        .sheet(isPresented: $makingNewSetting, onDismiss: nil) {
            TimeSetting(timeSetting: RemindTimeSetting(title: "New Setting", days: [1]), makingNewSetting: true)
        }
    }
}

struct TimeSettings_Previews: PreviewProvider {
    static var previews: some View {
//        TimeSettings(timeSettings: .constant([RemindTimeSetting(title: "broo", seconds: [1,10], hours: [1,2])]))
        TimeSettings(timeSettings: [RemindTimeSetting(title: "broo", seconds: [1,10], hours: [1,2])])
    }
}
