//
//  MoreTab.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 14/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct MoreTab: View {
    
    @State var showingPrivacyPolicy = false
    @State var showingDeveloper = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
                self.showingPrivacyPolicy = true
            }) {
                Text("Privacy Policy")
                    .font(.title)
            }
            .padding(5)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
            )
            
            Spacer()
            
            Button(action: {
                self.showingDeveloper = true
            }) {
                Text("Developer")
                    .font(.title)
            }
            .padding(5)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
            )
            
            Spacer()
        }.padding()
        .sheet(isPresented: $showingPrivacyPolicy) {
                PrivacyPolicy()
        }
        .sheet(isPresented: $showingDeveloper) {
                DeveloperPage()
        }
    }
}

//struct MoreTab_Previews: PreviewProvider {
//    static var previews: some View {
//        MoreTab()
//    }
//}
