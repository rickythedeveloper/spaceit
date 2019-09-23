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
    @FetchRequest(fetchRequest: TaskSaved.fetchRequest()) var tasksFetched: FetchedResults<TaskSaved>
    @State var showingAnswer = false
    @State var tasksSavedDue = [TaskSaved]()
    @State private var addingNewSR = false
    @State private var editingCard = false
    @State private var putOffIDs = [UUID]()
    
    var sectionName: String
    
    private let diffButtonImgs = ["hand.thumbsup.fill", "hand.thumbsup", "hand.thumbsdown", "hand.thumbsdown.fill"]
    
    var body: some View {
        VStack {
            GADBannerViewController(adUnitID: "ca-app-pub-3940256099942544/2934735716")
                .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
            Divider()
            
            HStack {
                Button(action: {self.addingNewSR = true}) {
                    Image(systemName: "plus.circle")
                        .sheet(isPresented: self.$addingNewSR, onDismiss: self.refresh) {
                            AddSR().environment(\.managedObjectContext, self.managedObjectContext)
                        }
                }
                Spacer()
                
                Text(self.sectionName)
                
                Spacer()
                Button(action: self.refresh) {
                    Image(systemName: "arrow.clockwise")
                }
            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            .font(.title)
            
            ZStack {

                if self.tasksSavedDue.count >= 2 {
                    ForEach((1..<self.tasksSavedDue.count).reversed(), id: \.self) { index in
                        TaskCard(task: self.tasksSavedDue[index], showingAnswer: .constant(false))
                    }
                }

                if self.tasksSavedDue.count > 0 {
                    TaskCard(task: self.tasksSavedDue[0], showingAnswer: self.$showingAnswer)
                }
            }
            
            if self.tasksSavedDue.count > 0 {
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
                    
                    if self.tasksSavedDue.count > 1 {
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
                                    CardEditView(task: self.tasksSavedDue[0], afterDismissing: self.refresh).environment(\.managedObjectContext, self.managedObjectContext)
                                }
                        }.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                    }
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

        self.tasksSavedDue = self.tasksFetched.dueTasks()
        self.tasksSavedDue.sortByDueDate()
        
        for putOffID in self.putOffIDs {
            var index = 0
            for eachTask in self.tasksSavedDue {
                if putOffID == eachTask.id {
                    self.tasksSavedDue.moveItemToLast(fromIndex: index)
                }
                index += 1
            }
        }
    }
    
    private func putOffPressed() {
        self.putOffIDs.append(tasksSavedDue[0].id)
        self.tasksSavedDue.moveItemToLast(fromIndex: 0)
        self.onSomeAction()
    }
    
    private func editPressed() {
        self.editingCard = true
    }
    
    private func difficultyDecided(diff: Int, outOf num: Int) {
        guard num != 0 else {return}
        let relativeDiff = Double(diff/num)
        
        if let task = self.tasksFetched.findTask(self.tasksSavedDue[0]) {
            task.prepareForNext(difficulty: relativeDiff)
            self.managedObjectContext.saveContext()
            registerNotification(task: task)
        }
        self.tasksSavedDue.remove(at: 0)
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
}
