//
//  UpcomingLIstCell.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/10/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct UpcomingCell: View {
    var task: TaskSaved
    
    var body: some View {
        TaskCell(task: task, showBreadcrumbs: true, showDueDate: true, showCreationDate: false)
    }
}

struct allTaskCell: View {
    var task: TaskSaved
    
    var body: some View {
        TaskCell(task: task, showBreadcrumbs: true, showDueDate: false, showCreationDate: false)
    }
}

struct pageCardCell: View {
    var task: TaskSaved
    
    var body: some View {
        TaskCell(task: task, showBreadcrumbs: false, showDueDate: false, showCreationDate: false)
    }
}

struct creationHistoryCell: View {
    var task: TaskSaved
    
    var body: some View {
        TaskCell(task: task, showBreadcrumbs: true, showDueDate: false, showCreationDate: true)
    }
}

struct TaskCell: View {
    
    var task: TaskSaved
    
    var showBreadcrumbs: Bool
    var showDueDate: Bool
    var showCreationDate: Bool
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(self.task.question)
                        .opacity(self.task.isActive ? 1.0 : 0.4)
                    Spacer()
                }
                
                if self.task.page != nil && self.showBreadcrumbs {
                    HStack {
                        Text(self.task.page!.breadCrumb())
                            .opacity(self.task.isActive ? 0.6 : 0.2)
                            .font(.caption)
                        Spacer()
                    }
                    
                }
            }.multilineTextAlignment(.leading)
            
            Spacer()
            
            if self.showDueDate {
                Text(self.task.dueDateStringShort())
                    .opacity(self.task.isActive ? 0.9 : 0.2)
                    .font(.callout)
            } else if self.showCreationDate && self.task.creationDateString() != nil {
                Text(self.task.creationDateString()!)
                    .opacity(self.task.isActive ? 0.9 : 0.2)
                    .font(.callout)
            }
        }.foregroundColor(task.isDue() && task.isActive ? .red : nil)
    }
}

//struct UpcomingLIstCell_Previews: PreviewProvider {
//    static var previews: some View {
//        UpcomingLIstCell()
//    }
//}
