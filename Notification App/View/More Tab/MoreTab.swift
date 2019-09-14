//
//  MoreTab.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 14/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct MoreTab: View {
    
    var sectionName: String
    
    @State var showingPrivacyPolicy = false
    
    var body: some View {
        VStack {
            
            HStack {
                Text(self.sectionName)
                    .font(.largeTitle)
                Spacer()
            }
            Spacer()
            
            Button(action: {
                self.showingPrivacyPolicy = true
            }) {
                Text("Privacy Policy")
                    .font(.title)
            }
            
            Spacer()
        }.padding()
        .sheet(isPresented: $showingPrivacyPolicy) {
                PrivacyPolicy()
        }
    }
}

//struct MoreTab_Previews: PreviewProvider {
//    static var previews: some View {
//        MoreTab()
//    }
//}
