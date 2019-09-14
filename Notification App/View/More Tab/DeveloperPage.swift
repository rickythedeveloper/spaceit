//
//  DeveloperPage.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 14/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct DeveloperPage: View {
    
    let devName = "Ricky Kawagishi"
    let intro = "Hi, my name is Ricky, and I am an amateur developer just turning some of my everyday ideas into reality. This is my first ever official app.\n\nI hope you enjoy using it and if you do, please go give it a 5-star rating on App Store as it would help to get more people to use it!\n\nIf you have any suggestions/feedback, please email me at\nrintaro.kawagishi.developer@gmail.com"
//    let emailAddress = "rintaro.kawagishi.developer@gmail.com"
//    let emailBody = "Your name:\nAny suggestions/feedback:\n\n\n-----\n\(UIDevice.current.model), iOS \(UIDevice.current.systemVersion)"
    
    var body: some View {
        NavigationView {
            VStack {
                Text(self.devName)
                    .font(.title)
                    .padding()
                Text(self.intro)
                    .padding()
//                Text(self.emailAddress)
                Spacer()
            }.navigationBarTitle("Developer")
            .padding()
        }
    }
}

struct DeveloperPage_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperPage()
    }
}
