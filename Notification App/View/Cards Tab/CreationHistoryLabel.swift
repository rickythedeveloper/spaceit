//
//  CreationHistoryLabel.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 20/10/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct CreationHistoryLabel: View {
    var task: TaskSaved
    var showingDescriptions: Bool
    
    var body: some View {
        VStack {
            if self.showingDescriptions {
                Text("Creation Date")
                    .font(.caption)
            }
            Text(self.task.creationDateString()!)
        }.opacity(self.task.isActive ? 0.9 : 0.2)
    }
}
