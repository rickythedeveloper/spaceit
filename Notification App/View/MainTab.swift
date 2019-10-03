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
    
    let SRTitle = "Review"
    let notifSenderTitle = "Notif Sender"
    
    var body: some View {
        
        TabView {
            ReviewSR(sectionName: SRTitle)
                .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                .tabItem {
                    Image(systemName: "rectangle.stack.fill")
                    Text(self.SRTitle)
                }
            
            CardListView()
                .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                .tabItem {
                    Image(systemName: "rectangle.stack.fill")
                    Text("Cards")
                }
            
            PageStructureView()
                .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Workspace")
            }
            
//            AddNewReminder(sectionName: self.notifSenderTitle).environmentObject(userSettings)
//                .tabItem {
//                    Image(systemName: "exclamationmark")
//                    Text(self.notifSenderTitle)
//                }
            
//            MoreTab()
//                .tabItem {
//                    Image(systemName: "ellipsis")
//                    Text("About")
//                }
        }
    }
}

struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
    }
}
