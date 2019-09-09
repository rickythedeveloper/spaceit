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
    
    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            TextField("Details (optional)", text: $details)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            HStack {
                Button(action: buttonTapped) {
                    Text("Send")
                        .font(.title)
                }
                .disabled(title == "")
                .padding()
                
                Button(action: {
                    self.checkingSettings = true
                }) {
                    Text("i")
                        .font(.title)
                }
                .padding()
            }
        }
        .offset(x: 0.0, y: -100.0)
        .padding()
        .sheet(isPresented: $checkingSettings, onDismiss: nil) {
            TimeSettings(timeSettings: self.userSettings.remindTimeSettings)
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
        if details == "" {
            nc.sendNotification(title: title, body: nil)
        } else {
            nc.sendNotification(title: title, body: details)
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
