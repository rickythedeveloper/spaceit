//
//  CardEditView.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 15/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct CardEditView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: TaskSaved.fetchRequest()) var tasksFetched: FetchedResults<TaskSaved>
    var task: TaskSaved
    
    @State private var choosingPage = false
    @State private var deleteChecking = false
    @State private var isShowing = true // this protects the view disappearing before the textfields, which in turn prevents the app from crashing. (Since they keyboard guardian needs the geometry of the textfieds...)
    @State private var alertShowing = false
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 2)
    
    @State var question = ""
    @State var answer = ""
    @State private var taskIsActive = true
    
    var afterDismissing: () -> Void = {}
    
    var body: some View {
        VStack {
//            Spacer()
            if self.isShowing {
                
                if tasksFetched.concept(id: self.task.id)?.page?.breadCrumb() != nil {
                    Button(action: {self.choosingPage = true}) {
                        Text(tasksFetched.concept(id: self.task.id)!.page!.breadCrumb())
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
                
                Divider()
            
            
                VStack {
                    HStack {
                        Text("Front")
                        Spacer()
                    }
                    MultiLineTF(text: self.$question, fontSize: CGFloat(20.0), index: 0, kGuardian: kGuardian)
                        .frame(maxWidth: .infinity, maxHeight: 150, alignment: .center)
                        .background(GeometryGetter(rect: self.$kGuardian.rects[0]))
                        .alert(isPresented: self.$alertShowing) {
                            Alert.invalidQuestion()
                        }
                    
                    HStack {
                        Text("Back")
                        Spacer()
                    }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    MultiLineTF(text: self.$answer, fontSize: CGFloat(20.0), index: 1, kGuardian: kGuardian)
                        .frame(maxWidth: .infinity, maxHeight: 250, alignment: .center)
                        .background(GeometryGetter(rect: self.$kGuardian.rects[1]))
                }.padding()
            }
            
            HStack {
                Spacer()
                Button(action: {self.deleteChecking = true}) {
                    Image(systemName: "trash.circle")
                        .imageScale(.large)
                        .font(.title)
                        
                }.alert(isPresented: self.$deleteChecking) {
                    Alert.deleteTask(deleteAction: self.deleteTask)
                }
                Spacer()
                
                Button(action: {
                    self.taskIsActive.toggle()
                }) {
                    (self.taskIsActive ? Image(systemName: "nosign") : Image(systemName: "arrow.up.bin"))
                        .imageScale(.large)
                        .font(.title)
                }
                
                Spacer()
                Button(action: self.tickPressed) {
                    Image(systemName: "checkmark.circle")
                        .imageScale(.large)
                        .font(.title)
                }
                Spacer()
            }.padding(.bottom)
            
            VStack {
                HStack {
                    VStack(alignment: .trailing) {
                        Text("Status:")
                        Text("Review interval:")
                            .opacity(self.task.isActive ? 1.0 : 0.3)
                    }.multilineTextAlignment(.trailing)
                    
                    VStack(alignment: .leading) {
                        Text(!self.task.isActive ? "Inactive" : "Due on \(self.task.dueDateStringShort())")
                            .foregroundColor((self.task.isActive && self.task.isDue()) ? .red :  nil)
                        Text(self.task.waitTimeString())
                            .opacity(self.task.isActive ? 1.0 : 0.3)
                    }.multilineTextAlignment(.leading)
                    
                }
            }
            
            Spacer()
        }
        .padding()
        .onAppear(perform: self.setup)
        .navigationBarTitle("Edit card", displayMode: .inline)
        .offset(y: self.kGuardian.slide).animation(.easeInOut(duration: 0.2))
        .background(Color(red: 0.5, green: 0.5, blue: 0.5).opacity(0.01)) // this background view is just so the gesture is recgnised everywhere.
        .gesture(
            DragGesture()
                .onChanged {value in
                    UIApplication.shared.endEditing()
                }
        )
    }
    
    private func setup() {
        self.question = task.question
        
        if let answer = task.answer {
            self.answer = answer
        } else {
            self.answer = ""
        }
        self.taskIsActive = self.task.isActive
    }
    
    private func deleteTask() {
        withAnimation(.easeInOut(duration: 0.5)) {
            self.isShowing = false
        }
        
        self.managedObjectContext.delete(self.task)
        self.managedObjectContext.saveContext()
        self.presentationMode.wrappedValue.dismiss()
        
        self.afterDismissing()
    }
    
    private func tickPressed() {
        guard self.question.hasContent() else {
            self.alertShowing = true
            return
        }
        
        let duration = 0.3
        let buffer = 0.1
        withAnimation(.easeInOut(duration: duration)) {
            self.isShowing = false
        }
        
        _ = Timer.scheduledTimer(withTimeInterval: duration + buffer, repeats: false, block: { (timer) in
            self.updateData()
        })
    }
    
    private func updateData() {
        task.question = self.question
        task.answer = (self.answer != "") ? self.answer : nil
        task.isActive = self.taskIsActive
        managedObjectContext.saveContext(completion: {
            self.presentationMode.wrappedValue.dismiss()
            self.afterDismissing()
        }, errorHandler: {
            self.presentationMode.wrappedValue.dismiss()
            self.afterDismissing()
//            TO DO: handle the error.
        })
    }
    
    private func addPage(page: Page?) {
        self.tasksFetched.concept(id: self.task.id)?.page = page
        self.managedObjectContext.saveContext()
    }
}
