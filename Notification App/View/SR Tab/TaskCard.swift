//
//  TaskCard.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct TaskCard: View {
    var task: TaskSaved?
    var isBaseCard: Bool = false
    @Binding var showingAnswer: Bool
    
    var body: some View {
        ZStack {
            (self.isBaseCard ? Color.gray.opacity(0.3) : self.task!.colour)
                .opacity(0.98)
                .cornerRadius(20.0)
                .rotationEffect(self.isBaseCard ? Angle(degrees: 0.0) : self.task!.angle)
                
            VStack {
                Text(self.isBaseCard ? "No card to review" : self.task!.question)
                    .font(.largeTitle)
                
                if !self.isBaseCard && self.task!.page != nil {
                    Text(self.task!.page!.breadCrumb())
                        .font(.body)
                        .opacity(0.5)
                }

                if !self.isBaseCard {
                    if self.task!.answer != nil && self.showingAnswer {
                        ScrollView {
                            Text(self.task!.answer!)
                                .padding()
                        }
                    } else if self.task!.answer != nil && !(self.showingAnswer) {
                        Image(systemName: "text.alignleft")
                            .opacity(0.5)
                    }
                }
            }.padding()
        }
            .padding()
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.showingAnswer.toggle()
                }
            }
    }
}

//struct TaskCard_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskCard()
//    }
//}
