//
//  TimeSettings.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 09/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct TimeSettings: View {
    
//    var timeSettings: [RemindTimeSetting]
    @EnvironmentObject private var userSettings: UserSettings
    
    let newSetting = RemindTimeSetting(title: "New Setting", days: [1])
    
    var body: some View {
        
        List(0...userSettings.remindTimeSettings.count, id: \.self) { index in
            if index < self.userSettings.remindTimeSettings.count {
                NavigationLink(destination: TimeSetting(index: index, thisSetting: self.userSettings.remindTimeSettings[index]).environmentObject(self.userSettings)) {
                    Text(self.userSettings.remindTimeSettings[index].title)
                }
            } else {
                Button(action: {
                    self.userSettings.remindTimeSettings.append(self.newSetting)
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
            }
            
        }
        .navigationBarTitle(Text("Settings"), displayMode: .inline)
    }
}

struct TimeSettings_Previews: PreviewProvider {
    static var previews: some View {
        TimeSettings().environmentObject(UserSettings())
    }
}
