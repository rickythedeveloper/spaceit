//
//  TaskCard.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct TaskCard: View {
    var task: Task
    
//    @State private var showingAnswer = false
    @Binding var showingAnswer: Bool
    
    var body: some View {
        GeometryReader { viewGeometry in
            ZStack {
                self.task.colour
                    .opacity(0.95)
                    .cornerRadius(20.0)
                    .rotationEffect(self.task.angle)
                    
                VStack {
                    Text(self.task.question)
                        .font(.largeTitle)
                        .animation(.easeInOut(duration: 0.07))
                    
                    if self.task.answer != nil && self.showingAnswer {
                        Text(self.task.answer!)
                            .animation(.easeInOut(duration: 0.07))
                            .padding()
                    }
                }.padding()
                
            }
                .padding()
                .onTapGesture {
                    self.showingAnswer.toggle()
                }
                .animation(.easeInOut(duration: 0.07))
        }
    }
}

//struct TaskCard_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskCard()
//    }
//}
