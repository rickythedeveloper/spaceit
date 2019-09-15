//
//  ReviewSR.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct ReviewSR: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: TaskSaved.getAllItems()) var tasksFetched: FetchedResults<TaskSaved>
    @State var sliderValue = 0.5
    @State var translation = CGSize.zero
    @State var showingAnswer = false
    @State var coreDataTaskStore = TaskStore(tasks: [Task]())
    @State var tasksDue = [Task]()
    @State private var addingNewSR = false
    @State private var editingCard = false
    
    var sectionName: String
    
    var body: some View {
        VStack {
            GADBannerViewController(adUnitID: "ca-app-pub-3940256099942544/2934735716")
                .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
            Divider()
            
            HStack {
                Button(action: {
                    self.addingNewSR = true
                }) {
                    Image(systemName: "plus.circle")
                    .sheet(isPresented: self.$addingNewSR, onDismiss: self.refresh) {
                        AddSR().environment(\.managedObjectContext, self.managedObjectContext)
                    }
                }
                Spacer()
                
                Text(self.sectionName)
                
                Spacer()
                Button(action: {
                    self.refresh()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            .font(.title)
            
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
                        Button(action: self.putOffPressed) {
                            Text("Put off")
                        }
                    }
                    
                    Spacer()
                    Button(action: self.donePressed) {
                        Text("Done")
                    }
                    
                    Spacer()
                    Button(action: self.editPressed) {
                        Text("Edit")
                        .sheet(isPresented: self.$editingCard, onDismiss: nil) {
                            CardEditView(task: self.tasksDue[0]).environment(\.managedObjectContext, self.managedObjectContext)
                        }
                    }
                    
                    Spacer()
                    Button(action: self.deletePressed) {
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
        }
            .onAppear(perform: self.refresh)
            .padding()
            
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
    
    private func putOffPressed() {
        self.tasksDue.moveItemToLast(fromIndex: 0)
        self.onSomeAction()
    }
    
    private func donePressed() {
        if let task = self.coreDataTaskStore.findTask(self.tasksDue[0]) {
            task.prepareForNext(difficulty: self.sliderValue)
            
            for eachTaskFetched in self.tasksFetched {
                if eachTaskFetched.id == task.id {
                    eachTaskFetched.setValue(task.lastChecked, forKey: "lastChecked")
                    eachTaskFetched.setValue(task.waitTime, forKey: "waitTime")
                    self.saveContext()
                }
            }
            registerNotification(task: task)
        }
        self.tasksDue.remove(at: 0)
        self.onSomeAction()
    }
    
    private func editPressed() {
        self.editingCard = true
    }
    
    private func deletePressed() {
        for eachTaskFetched in self.tasksFetched {
            if eachTaskFetched.id == self.tasksDue[0].id {
                self.managedObjectContext.delete(eachTaskFetched)
                self.saveContext()
            }
        }
        self.tasksDue.remove(at: 0)
        self.onSomeAction()
    }
    
    func registerNotification(task: Task) {
        let nc = UNUserNotificationCenter.current()
        nc.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                nc.sendSRTaskNotification(task: task)
            default:
                nc.requestAuthorization(options: [.alert]) { (granted, error) in
                    if !granted, let error = error {
                        fatalError(error.localizedDescription)
                    } else {
                        nc.sendSRTaskNotification(task: task)
                    }
                }
            }
        }
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
