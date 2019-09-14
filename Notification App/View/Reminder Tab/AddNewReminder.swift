//
//  AddNewReminder.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 09/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct AddNewReminder: View {
    
    @EnvironmentObject private var userSettings: UserSettings
    
    @State private var title = ""
    @State private var details = ""
    @State private var selectedIndex = 0
    @State private var showingPrivacyPolicy = false
    
    var sectionName: String
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Title", text: $title)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                
                TextField("Details (optional)", text: $details)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                
                List(0..<userSettings.remindTimeSettings.count, id: \.self) { index in
                    Button(action: {
                        self.selectedIndex = index
                        UIApplication.shared.endEditing()
                    }) {
                        HStack {
                            Text(self.userSettings.remindTimeSettings[index].title)
                            Spacer()
                            if index == self.selectedIndex {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }.gesture(
                    DragGesture()
                        .onChanged {value in
                            UIApplication.shared.endEditing()
                        }
                )
                
                
                Button(action: buttonTapped) {
                    Text("Send")
                        .font(.title)
                }
                .disabled(title == "")
                .padding()
                
                Spacer()
            }
            .navigationBarTitle(Text(self.sectionName), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.showingPrivacyPolicy = true
            }) {
                Image(systemName: "info.circle.fill")
                    .imageScale(.large)
            }, trailing: NavigationLink(destination: TimeSettings().environmentObject(self.userSettings)) {
                Image(systemName: "ellipsis")
                    .imageScale(.large)
            })
            .sheet(isPresented: self.$showingPrivacyPolicy, content: {
                PrivacyPolicy()
            })
            .padding()
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
                        fatalError(error.localizedDescription)
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

//struct AddNewReminder_Previews: PreviewProvider {
//    static var previews: some View {
//        AddNewReminder().environmentObject(UserSettings())
//    }
//}
