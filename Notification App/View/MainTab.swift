//
//  MainTab.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct MainTab: View {
    
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        
        TabView {
            AddNewReminder().environmentObject(userSettings)
                .tabItem {
                    Text("a")
                }
            
            ReviewSR().environmentObject(userSettings.allTaskStore)
                .tabItem {
                    Text("b")
                }
        }
    }
}

struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
    }
}
