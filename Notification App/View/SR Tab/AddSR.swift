//
//  AddSR.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 14/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct AddSR: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: TaskSaved.fetchRequest()) var tasksFetched: FetchedResults<TaskSaved>
    
    var preChosenPage: Page?
    
    @State private var choosingPage = false
    @State private var chosenPage: Page?
    @State private var question: String = ""
    @State private var answer: String = ""
    @State private var isShowing = true // this protects the view disappearing before the textfields, which in turn prevents the app from crashing. (Since they keyboard guardian needs the geometry of the textfieds...)
    @State private var alertShowing = false
    @ObservedObject var kGuardian = KeyboardGuardian(textFieldCount: 2)
    
    var body: some View {
        VStack {
            ZStack {
                Text("New spaced repetition")
                    .font(.title)
                
                HStack {
                    Button(action: {
                        self.dismissView()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title)
                    }
                    
                    Spacer()
                }
            }
            
            if self.chosenPage != nil {
                Button(action: {self.choosingPage = true}) {
                    Text(self.chosenPage!.breadCrumb())
                        .sheet(isPresented: self.$choosingPage) {
                            PageStructureView(isInSelectionMode: true, onSelection: self.addPage(page:)).environment(\.managedObjectContext, self.managedObjectContext)
                        }
                }
            } else {
                Button(action: {self.choosingPage = true}) {
                    Text("Add page")
                        .sheet(isPresented: self.$choosingPage) {
                            PageStructureView(isInSelectionMode: true, onSelection: self.addPage(page:)).environment(\.managedObjectContext, self.managedObjectContext)
                        }
                }
            }
            
            
            if self.isShowing {
                VStack {
                    HStack {
                        Text("Question/Concept/Reminder")
                        Spacer()
                    }
                    MultiLineTF(text: self.$question, fontSize: 20, index: 0, kGuardian: self.kGuardian)
                        .frame(maxWidth: 500, maxHeight: 100, alignment: .center)
                        .background(GeometryGetter(rect: self.$kGuardian.rects[0]))
                    
                    HStack {
                        Text("Answer/Hint (optional)")
                        Spacer()
                    }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    MultiLineTF(text: self.$answer, fontSize: 20, index: 1, kGuardian: self.kGuardian)
                        .frame(maxWidth: 500, maxHeight: 250, alignment: .center)
                        .background(GeometryGetter(rect: self.$kGuardian.rects[1]))
                }.padding()
            }
            
            
            Button(action: {
                self.addButtonPressed()
            }) {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
                    .font(.title)
            }
            
            Spacer()
            Text("The first reminder will be delivered in 24 hours.")
                .foregroundColor(.gray)
        }
            .offset(y: self.kGuardian.slide).animation(.easeInOut(duration: 0.2))
            .padding()
            .background(Color(red: 0.5, green: 0.5, blue: 0.5).opacity(0.01)) // this background view is just so the gesture is recgnised everywhere.
            .gesture(
                DragGesture()
                    .onChanged {value in
                        UIApplication.shared.endEditing()
                    }
            )
            .alert(isPresented: self.$alertShowing) {
                Alert.invalidQuestion()
            }
            .onAppear(perform: self.setup)
    }
    
    private func setup() {
        self.chosenPage = self.preChosenPage
    }
    
    private func dismissView() {
        self.isShowing = false
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func addButtonPressed() {
        guard self.question.hasContent() else {
            self.alertShowing = true
            return
        }
        
        let task = TaskSaved(context: self.managedObjectContext)
        task.id = UUID()
        task.question = self.question
        if self.answer.hasContent() {
            task.answer = self.answer
        } else {
            task.answer = nil
        }
        
        task.lastChecked = Date()
//        task.waitTime = 2
        task.waitTime = 60*60*24
        task.page = self.chosenPage
        
        self.managedObjectContext.saveContext()
        self.registerNotification(id: task.id, question: task.question, waitTime: task.waitTime)
        
        self.question = ""
        self.answer = ""
        
        self.dismissView()
    }
    
    func registerNotification(id: UUID, question: String, waitTime: TimeInterval) {
        let nc = UNUserNotificationCenter.current()
        nc.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                nc.sendSRTaskNotification(id: id, question: question, waitTime: waitTime)
            default:
                nc.requestAuthorization(options: [.alert]) { (granted, error) in
                    if !granted, let error = error {
                        fatalError(error.localizedDescription)
                    } else {
                        nc.sendSRTaskNotification(id: id, question: question, waitTime: waitTime)
                    }
                }
            }
        }
    }
    
    private func addPage(page: Page) {
        self.chosenPage = page
    }
}

//struct AddSR_Previews: PreviewProvider {
//    static var previews: some View {
//        AddSR()
//    }
//}
