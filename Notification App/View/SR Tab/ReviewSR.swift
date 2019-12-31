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
                    Text(String(self.tasksUnderChosenPage().count))
                        .font(.title)
                        .foregroundColor(.red)
                    if chosenPage == nil {
                        Text("cards to review in total")
                            .font(.caption)
                    } else {
                        Text("cards to review in this page")
                            .font(.caption)
                    }
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
                Text(self.chosenPage != nil ? "Reviewing: \(chosenPage!.breadCrumb())" : "Select Page to Review")
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
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
                    VStack {
                        HStack {
                            ForEach((0...3).reversed(), id: \.self) { num in
                                VStack {
                                    Button(action: {
                                        self.difficultyDecided(diff: num, outOf: 3)
                                    }) {
                                        if num == 0 || num == 3 {
                                            Image(systemName: self.diffButtonImgs[num])
                                                .font(.title)
                                                .padding([.horizontal])
                                        } else {
                                            Image(systemName: self.diffButtonImgs[num])
                                                .font(.title)
                                                .padding([.horizontal])
                                        }
                                    }
                                    
                                    Text("\(num)")
                                        .font(.caption)
                                        .scaleEffect(0.9)
                                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                                }
                                
                            }
                        }
                        
                        Text("<-----Difficulty------")
                            .font(.caption)
                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
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
                            
                            Text("Edit card")
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
        let relativeDiff = Double(diff) / Double(num)
        
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
    
    private func dueTasks() -> [TaskSaved] {
        return self.tasksFetched.dueTasks().sortedByDueDate().activeTasks().orderAccountingForPutOffs(putOffIDs: self.putOffIDs)
    }
    
    private func someDueTasks() -> [TaskSaved] {
        return self.dueTasks().elementsFromBeginning(number: maxNCardsShown)
    }
    
    private func tasksUnderChosenPage() -> [TaskSaved] {
        guard self.chosenPage != nil else {return self.dueTasks()}
        return self.chosenPage!.conceptsUnderThisPage().dueTasks().sortedByDueDate().activeTasks().orderAccountingForPutOffs(putOffIDs: self.putOffIDs)
    }
    
    private func someTasksUnderChosenPage() -> [TaskSaved] {
        return self.tasksUnderChosenPage().elementsFromBeginning(number: self.maxNCardsShown)
    }
}
