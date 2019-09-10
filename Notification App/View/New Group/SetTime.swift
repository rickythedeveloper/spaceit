//
//  SetTime.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 09/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct SetTime: View {
    
    @ObservedObject var remindTime: RemindTime
    
    var body: some View {
        
        GeometryReader { viewGeom in
            HStack {
                TextField("XX", text: self.$remindTime.numberStr)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                Divider()
                Picker(selection: self.$remindTime.typeInt, label: Text("")) {
                    ForEach(0..<TimeTypeStr.allCases.count, id:\.self) {n in
                        Text(TimeTypeStr.allCases[n].rawValue)
                            .font(.body)
                    }
                }//.frame(maxWidth: viewGeom.size.width / 2)
                .clipped()
            }
        }
    }
}

struct SetTime_Previews: PreviewProvider {
    static var previews: some View {
        SetTime(remindTime: RemindTime(number: 3, type: .days))
    }
}
