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
    
    let SRTitle = "Spaced Repetition"
    let notifSenderTitle = "Notif Sender"
    let moreTitle = "More"
    
    var body: some View {
        
        TabView {
            ReviewSR(sectionName: SRTitle)
                .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                .tabItem {
                    Image(systemName: "rectangle.stack.fill")
                    Text(self.SRTitle)
                }
            
            AddNewReminder(sectionName: self.notifSenderTitle).environmentObject(userSettings)
                .tabItem {
                    Image(systemName: "exclamationmark")
                    Text(self.notifSenderTitle)
                }
            
            MoreTab(sectionName: self.moreTitle)
                .tabItem {
                    Image(systemName: "ellipsis")
                    Text(self.moreTitle)
                }
        }
    }
}

struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
    }
}
