//
//  ReviewSR.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct ReviewSR: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: TaskSaved.getAllItems()) var tasksFetched: FetchedResults<TaskSaved>
    @State var sliderValue = 0.5
    @State var translation = CGSize.zero
    @State var showingAnswer = false
    @State var coreDataTaskStore = TaskStore(tasks: [Task]())
    @State var tasksDue = [Task]()
    @State private var addingNewSR = false
    
    var body: some View {
        VStack {
            
            HStack {
                Button(action: {
                    self.addingNewSR = true
                }) {
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                }
                Spacer()
                Button(action: {
                    self.refresh()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .imageScale(.large)
                }
            }
            
            ZStack {
                TaskCard(task: Task(question: "None left", answer: nil, colour: Color.gray, angle: Angle(degrees: 0)), showingAnswer: .constant(false))
                
                if self.tasksDue.count >= 2 {
                    ForEach((1..<self.tasksDue.count).reversed(), id: \.self) { index in
                        TaskCard(task: self.tasksDue[index], showingAnswer: .constant(false))
                    }
                }

                if self.tasksDue.count > 0 {
                    TaskCard(task: self.tasksDue[0], showingAnswer: self.$showingAnswer)
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
                    if self.tasksDue.count > 1 {
                        Spacer()
                        Button(action: {
//                            MARK: do not remove from all task store
                            self.tasksDue.moveItemToLast(fromIndex: 0)
                            self.onSomeAction()
                        }) {
                            Text("Put off")
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
//                        MARK: change the lastChecked and waitTime of the task inside coreDataTaskStore, remove the task from tasksDue
                        if let task = self.coreDataTaskStore.findTask(self.tasksDue[0]) {
                            task.prepareForNext(difficulty: self.sliderValue)
                            
                            for eachTaskFetched in self.tasksFetched {
                                if eachTaskFetched.id == task.id {
                                    eachTaskFetched.setValue(task.lastChecked, forKey: "lastChecked")
                                    eachTaskFetched.setValue(task.waitTime, forKey: "waitTime")
                                    self.saveContext()
                                }
                            }
                        }
                        self.tasksDue.remove(at: 0)
                        self.onSomeAction()
                    }) {
                        Text("Done")
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        for eachTaskFetched in self.tasksFetched {
                            if eachTaskFetched.id == self.tasksDue[0].id {
                                self.managedObjectContext.delete(eachTaskFetched)
                                self.saveContext()
                            }
                        }
                        self.tasksDue.remove(at: 0)
                        self.onSomeAction()
                    }) {
                        Text("Delete")
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                }.font(.title)
                .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 10.0, trailing: 0.0))
                
                
                Text("Difficulty \(String(Int((sliderValue*100).rounded()))) %")

                Slider(value: $sliderValue, in: 0.0...1.0, minimumValueLabel: Image(systemName: "hand.thumbsup.fill"), maximumValueLabel: Image(systemName: "hand.thumbsdown.fill")) {
                    Text("a")
                }
            }
        }.onAppear(perform: self.refresh)
        .padding()
            .sheet(isPresented: self.$addingNewSR, onDismiss: self.refresh) {
                AddSR().environment(\.managedObjectContext, self.managedObjectContext)
            }
    }
    
    func refresh() {
        self.refreshTasks()
        self.onSomeAction()
    }
    
    func refreshTasks() {
        var temporaryTasks = [Task]()
        for each in self.tasksFetched {
            temporaryTasks.append(Task(id: each.id, question: each.question, answer: each.answer, lastChecked: each.lastChecked, waitTime: each.waitTime))
        }
        self.coreDataTaskStore = TaskStore(tasks: temporaryTasks)
        
        self.tasksDue = self.coreDataTaskStore.dueTasks()
    }
    
    func onSomeAction() {
        self.printInfo()
        self.translation = CGSize.zero
        self.showingAnswer = false
    }
    
    func saveContext() {
        do {
            try self.managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func printInfo() {
        for each in self.coreDataTaskStore.tasks {
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
