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
    @State private var showingAnswer = false
    @State private var addingNewSR = false
    @State private var editingCard = false
    @State private var putOffIDs = [UUID]()
    @State private var choosingPage = false
    @State private var chosenPage: Page?
    
    private let diffButtonImgs = ["hand.thumbsup.fill", "hand.thumbsup", "hand.thumbsdown", "hand.thumbsdown.fill"]
    private let maxNCardsShown = 5
    
    var body: some View {
        VStack {
//            GADBannerViewController(adUnitID: "ca-app-pub-3940256099942544/2934735716")
//                .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
//            Divider()
            
            HStack {
                HStack {
                    Text("\(self.dueTasks().count)")
                        .font(.title)
                        .foregroundColor(.red)
                    Text("cards to review")
                        .font(.caption)
                }
                Spacer()
                Button(action: {self.addingNewSR = true}) {
                    Image(systemName: "plus.circle")
                        .sheet(isPresented: self.$addingNewSR, onDismiss: nil) {
                            AddSR().environment(\.managedObjectContext, self.managedObjectContext)
                        }
                }
            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            .font(.title)
            
            Button(action: {
                self.choosingPage = true
            }) {
                Text(self.chosenPage != nil ? chosenPage!.breadCrumb() : "Select page")
                    .sheet(isPresented: self.$choosingPage) {
                        PageStructureView(isInSelectionMode: true, onSelection: { (page) in
                            self.chosenPage = page
                        }).environment(\.managedObjectContext, self.managedObjectContext)
                    }
            }
            
            ZStack {
                TaskCard(task: nil, isBaseCard: true, showingAnswer: .constant(false))

                if self.someTasksUnderChosenPage().count > 1 {
                    ForEach((1..<self.someTasksUnderChosenPage().count).reversed(), id: \.self) { index in
                        TaskCard(task: self.someTasksUnderChosenPage()[index], showingAnswer: .constant(false))
                    }
                }

                if self.someTasksUnderChosenPage().count > 0 {
                    TaskCard(task: self.someTasksUnderChosenPage()[0], showingAnswer: self.$showingAnswer)
                }
            }
            
            if self.someTasksUnderChosenPage().count > 0 {
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
                    
                    if self.someTasksUnderChosenPage().count > 1 {
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
                                    CardEditView(task: self.someTasksUnderChosenPage()[0], afterDismissing: self.onEditingCard).environment(\.managedObjectContext, self.managedObjectContext)
                                }
                        }.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                    }
                }
            }
        }
            .padding()
            
    }
    
    private func onEditingCard() {
        self.showingAnswer.toggle()
        self.showingAnswer = false
    }
    
    private func putOffPressed() {
        withAnimation(.easeInOut(duration: 0.5)) {
            self.putOffIDs.append(self.someTasksUnderChosenPage()[0].id)
            self.onSomeAction()
        }
    }
    
    private func editPressed() {
        self.editingCard = true
    }
    
    private func difficultyDecided(diff: Int, outOf num: Int) {
        guard num != 0 else {return}
        let relativeDiff = Double(diff/num)
        
        withAnimation(.easeInOut(duration: 0.5)) {
            let task = self.someTasksUnderChosenPage()[0]
            task.prepareForNext(difficulty: relativeDiff)
            self.managedObjectContext.saveContext()
            self.registerNotification(task: task)
        }
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
    
    private func someDueTasks() -> [TaskSaved] {
        return self.limitedNUmberOfTasks(tasks: self.dueTasks())
    }
    
    private func someTasksUnderChosenPage() -> [TaskSaved] {
        guard self.chosenPage != nil else {return self.someDueTasks()}
        return limitedNUmberOfTasks(tasks: self.chosenPage!.conceptsUnderThisPage())
    }
    
    private func limitedNUmberOfTasks(tasks: [TaskSaved]) -> [TaskSaved] {
        guard self.maxNCardsShown >= 0 else {return [TaskSaved]()}
        
        var realNCardsShown: Int
        if self.maxNCardsShown > tasks.count {
            realNCardsShown = tasks.count
        } else {
            realNCardsShown = maxNCardsShown
        }
        
        var someTasks = [TaskSaved]()
        for each in 0..<realNCardsShown {
            someTasks.append(tasks[each])
        }
        return someTasks
    }
}
