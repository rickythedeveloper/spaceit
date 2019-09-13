//
//  PrivacyPolicy.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 12/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct PrivacyPolicy: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let infoUGiveToUsTitle = "Information you give to us"
    
    let infoUGiveToUsDetail = "We do not receive/process any of your information directly. i.e. any of the information you enter in this app remains inside the app and will not be transmitted anywhere. This excludes the data given to us via the third party service provider(s). Refer to the next section for this."
    
    let infoUGiveToOthersTitle = "Information you give to third party service provider(s)"
    
    let infoUGiveToOthersDetail = "We work with third party service provider(s) and may receive information about you from them. These service provider(s) collect usage data in compliance with their privacy policies. The service provider(s) this app uses:"
    
    let services = ["Google AdMob: This app uses Google's AdMob advertising service. Their privacy policy is available at: https://policies.google.com/privacy"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
//                    HStack {
//                        Text("Information you give to us")
//                            .font(.title)
//                        Spacer()
//                    }.padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 10.0, trailing: 0.0))
                    
                    Group {
                        TitleText(text: infoUGiveToUsTitle)
                        DetailText(text: infoUGiveToUsDetail)
                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0))
                    }.padding(EdgeInsets(top: 0, leading: 5, bottom: 10, trailing: 0))
                    
                    Group {
                        TitleText(text: infoUGiveToOthersTitle)
                        
                        Group {
                            DetailText(text: infoUGiveToOthersDetail)
                            ForEach(services, id: \.self) { service in
                                ServiceText(text: service)
                            }.padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0))
                        }.padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0))
                    }.padding(EdgeInsets(top: 0, leading: 5, bottom: 10, trailing: 0))
                    
                    
                }.padding()
            }
            .navigationBarTitle("Privacy Policy")
        }
    }
}

struct PrivacyPolicy_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicy()
    }
}

private struct TitleText: View {
    
    var text: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.title)
            Spacer()
        }//.padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 10.0, trailing: 0.0))
    }
}

private struct DetailText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .lineLimit(nil)
            .font(.body)
//            .padding()
            .foregroundColor(.gray)
    }
}

private struct ServiceText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .lineLimit(nil)
            .font(.body)
//            .padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 0))
            .foregroundColor(.green)
    }
}
