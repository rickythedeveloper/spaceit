//
//  ReviewSR.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct ReviewSR: View {
    
    @EnvironmentObject var allTaskStore: TaskStore
    @State var sliderValue = 0.5
    @State var translation = CGSize.zero
    
    @State var tasksDue = [Task]()
    
    var body: some View {
        VStack {
            ZStack {
                TaskCard(task: Task(question: "None left", answer: nil, colour: Color.gray, angle: Angle(degrees: 0)))
                
                if self.tasksDue.count >= 2 {
                    ForEach((1..<self.tasksDue.count).reversed(), id: \.self) { index in
                        TaskCard(task: self.tasksDue[index])
                    }
                }

                if self.tasksDue.count > 0 {
                    TaskCard(task: self.tasksDue[0])
                        .gesture(
                            DragGesture()
                                .onChanged({ (value) in
                                    self.translation.width += value.translation.width
                                    self.translation.height += value.translation.height
                                })
                                .onEnded({ (value) in
                                    self.translation = .zero
                                })
                        )
                        .offset(self.translation)
                }
            }
            
            if self.tasksDue.count > 0 {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.tasksDue.moveItemToLast(fromIndex: 0)
//                        MARK: do not remove from all task store
                        self.translation = CGSize.zero
                        self.printInfo()
                    }) {
                        Text("Put off")
                    }
                    
                    Spacer()
                    
                    Button(action: {
//                        MARK: change the lastChecked and waitTime of the task inside allTaskStore, remove the task from tasksDue
                        if let task = self.allTaskStore.findTask(self.tasksDue[0]) {
                            task.prepareForNext(difficulty: self.sliderValue)
                        }
                        self.tasksDue.remove(at: 0)
                        self.translation = CGSize.zero
                        self.printInfo()
                    }) {
                        Text("Done")
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        self.allTaskStore.removeTask(self.tasksDue[0])
                        self.tasksDue.remove(at: 0)
                        self.translation = CGSize.zero
                        self.printInfo()
                    }) {
                        Text("Delete")
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                }.font(.title)
                .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 10.0, trailing: 0.0))
                
                
                Text("Difficulty \(String(Int((sliderValue*100).rounded()))) %")

                Slider(value: $sliderValue, in: 0.0...1.0, minimumValueLabel: Text("min"), maximumValueLabel: Text("max")) {
                    Text("a")
                }
            }
        }.onAppear(perform: {self.tasksDue = self.allTaskStore.dueTasks()})
        .padding()
    }
    
    func printInfo() {
        for each in self.allTaskStore.tasks {
            print(each.question)
            print(each.waitTime)
        }
        print("\n\n")
    }
}

//struct ReviewSR_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewSR()
//    }
//}
