//
//  ReviewSR.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI
//import GoogleMobileAds

struct ReviewSR: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: TaskSaved.fetchRequest()) var tasksFetched: FetchedResults<TaskSaved>
    @State var showingAnswer = false
    @State private var addingNewSR = false
    @State private var editingCard = false
    @State private var putOffIDs = [UUID]()
    
    var sectionName: String
    
    private let diffButtonImgs = ["hand.thumbsup.fill", "hand.thumbsup", "hand.thumbsdown", "hand.thumbsdown.fill"]
    
    var body: some View {
        VStack {
//            GADBannerViewController(adUnitID: "ca-app-pub-3940256099942544/2934735716")
//                .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
//            Divider()
            
            HStack {
                Spacer()
                Button(action: {self.addingNewSR = true}) {
                    Image(systemName: "plus.circle")
                        .sheet(isPresented: self.$addingNewSR, onDismiss: nil) {
                            AddSR().environment(\.managedObjectContext, self.managedObjectContext)
                        }
                }
            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            .font(.title)
            
            ZStack {
                TaskCard(task: nil, isBaseCard: true, showingAnswer: .constant(false))

                if self.dueTasks().count > 1 {
                    ForEach((1..<self.dueTasks().count).reversed(), id: \.self) { index in
                        TaskCard(task: self.dueTasks()[index], showingAnswer: .constant(false))
                    }
                }

                if self.dueTasks().count > 0 {
                    TaskCard(task: self.dueTasks()[0], showingAnswer: self.$showingAnswer)
                }
            }
            
            if self.dueTasks().count > 0 {
                HStack {
                    ForEach((0...3).reversed(), id: \.self) { num in
                        Button(action: {
                            self.difficultyDecided(diff: num, outOf: 3)
                        }) {
                            if num == 0 || num == 3 {
                                Image(systemName: self.diffButtonImgs[num])
                                    .font(.title)
                                    .padding()
                            } else {
                                Image(systemName: self.diffButtonImgs[num])
                                    .padding()
                            }
                        }
                    }
                    
                    if self.dueTasks().count > 1 {
                        Button(action: self.putOffPressed) {
                            VStack {
                                Image(systemName: "arrow.turn.right.up")
                                    .font(.title)
                                
                                Text("Put off")
                                    .font(.caption)
                                    .opacity(0.7)
                            }
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                    }
                    
                    Button(action: self.editPressed) {
                        VStack {
                            Image(systemName: "pencil")
                                .font(.title)
                            
                            Text("Edit")
                                .font(.caption)
                                .opacity(0.7)
                                .sheet(isPresented: self.$editingCard, onDismiss: nil) {
                                    CardEditView(task: self.dueTasks()[0]).environment(\.managedObjectContext, self.managedObjectContext)
                                }
                        }.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                    }
                }
            }
        }
            .padding()
            
    }
    
    private func putOffPressed() {
        self.putOffIDs.append(self.dueTasks()[0].id)
        self.onSomeAction()
    }
    
    private func editPressed() {
        self.editingCard = true
    }
    
    private func difficultyDecided(diff: Int, outOf num: Int) {
        guard num != 0 else {return}
        let relativeDiff = Double(diff/num)
        
        let task = self.dueTasks()[0]
        task.prepareForNext(difficulty: relativeDiff)
        self.managedObjectContext.saveContext()
        self.registerNotification(task: task)
        self.onSomeAction()
    }
    
    func registerNotification(task: TaskSaved) {
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
        for each in self.tasksFetched {
            print(each.question)
            print(each.waitTime)
        }
        print("\n\n")
    }
    
    private func dueTasks() -> [TaskSaved] {
        var tasks = self.tasksFetched.dueTasks().sortedByDueDate().activeTasks()

        for putOffID in self.putOffIDs {
            var index = 0
            for eachTask in tasks {
                if putOffID == eachTask.id {
                    tasks.moveItemToLast(fromIndex: index)
                }
                index += 1
            }
        }
        return tasks
    }
}
