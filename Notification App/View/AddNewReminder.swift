//
//  AddNewReminder.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 09/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct AddNewReminder: View {
    
    @EnvironmentObject var userSettings: UserSettings
    
    @State var title = ""
    @State var details = ""
    @State var checkingSettings = false
    @State var selectedIndex = 0
    
    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            TextField("Details (optional)", text: $details)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            List(0...userSettings.remindTimeSettings.count, id: \.self) { index in
                Button(action: {
                    self.selectedIndex = index
                }) {
                    HStack {
                        if index == 0 {
                            Text("Now")
                        } else {
                            Text(self.userSettings.remindTimeSettings[index-1].title)
                        }
                        Spacer()
                        if index == self.selectedIndex {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            
            Button(action: {
                self.checkingSettings = true
            }) {
                Image(systemName: "info.circle")
                    .imageScale(.large)
            }
            .padding()
            
            Button(action: buttonTapped) {
                Text("Send")
                    .font(.title)
            }
            .disabled(title == "")
            .padding()
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $checkingSettings, onDismiss: nil) {
            TimeSettings().environmentObject(self.userSettings)
        }
    }
    
    private func buttonTapped() {
        let nc = UNUserNotificationCenter.current()
        nc.delegate = NotificationDelegate.shared
        nc.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                self.sendNotification(with: nc)
            default:
                nc.requestAuthorization(options: [.alert]) { (granted, error) in
                    if !granted, let error = error {
                        // handle this
                    } else {
                        self.sendNotification(with: nc)
                    }
                }
            }
        }
    }
    
    private func sendNotification(with nc: UNUserNotificationCenter) {
        
        var detailStr: String?
        if details == "" {
            detailStr = nil
        } else {
            detailStr = details
        }
        
        if selectedIndex == 0 {
            nc.sendNotification(requestID: nil, title: title, body: detailStr, remindTimeSetting: nil)
        } else {
            nc.sendNotification(requestID: nil, title: title, body: detailStr, remindTimeSetting: userSettings.remindTimeSettings[selectedIndex-1])
        }
        
        title = ""
        details = ""
    }
}

struct AddNewReminder_Previews: PreviewProvider {
    static var previews: some View {
        AddNewReminder().environmentObject(UserSettings())
    }
}
