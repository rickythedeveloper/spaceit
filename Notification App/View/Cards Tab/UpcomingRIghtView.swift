//
//  UpcomingRIghtView.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 20/10/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct UpcomingRIghtView: View {
    
    var task: TaskSaved
    var showingDescriptions: Bool
    
    let normalOpacity = 0.9
    let inactiveOpacity = 0.2
    
    var body: some View {
        HStack {
            if self.showingDescriptions {
                VStack(alignment: .trailing) {
                    Text("Due:")
                    Text("Interval:")
                }.font(.caption)
            }
            
            VStack(alignment: .trailing) {
                Text(self.task.dueDateStringShort())
                Text(self.task.waitTimeString())
            }.font(.caption)
        }.opacity(self.task.isActive ? self.normalOpacity : self.inactiveOpacity)
        
        
    }
}
