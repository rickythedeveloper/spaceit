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
    @FetchRequest(fetchRequest: TaskSaved.getAllItems()) var tasksFetched: FetchedResults<TaskSaved>
    var task: Task
    
    @State private var isShowing = true // this protects the view disappearing before the textfields, which in turn prevents the app from crashing. (Since they keyboard guardian needs the geometry of the textfieds...)
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 2)
    
    @State var question = ""
    @State var answer = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            if self.isShowing {
                VStack {
                    HStack {
                        Text("Question/Concept/Reminder")
                        Spacer()
                    }
                    MultiLineTF(text: self.$question, fontSize: CGFloat(20.0), index: 0, kGuardian: kGuardian)
                        .frame(maxWidth: 500, maxHeight: 100, alignment: .center)
                        .background(GeometryGetter(rect: self.$kGuardian.rects[0]))
                    
                    HStack {
                        Text("Answer/Hint (optional)")
                        Spacer()
                    }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    MultiLineTF(text: self.$answer, fontSize: CGFloat(20.0), index: 1, kGuardian: kGuardian)
                        .frame(maxWidth: 500, maxHeight: 250, alignment: .center)
                        .background(GeometryGetter(rect: self.$kGuardian.rects[1]))
                }.padding()
            }
            
            Button(action: {
                self.updateData()
                self.isShowing = false
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "checkmark.circle")
                    .imageScale(.large)
                    .font(.title)
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
    }
    
    private func updateData() {
        task.question = self.question
        task.answer = (self.answer != "") ? self.answer : nil
        
        if let taskToBeSaved = self.findCoreDataObject(thatMatches: self.task) {
            taskToBeSaved.question = self.task.question
            taskToBeSaved.answer = self.task.answer
        } else {
            fatalError("Could not find a core data object that matches the task. id: \(self.task.id), question: \(self.task.question)\n\n")
        }
        managedObjectContext.saveContext()
    }
    
    private func findCoreDataObject(thatMatches task: Task) -> TaskSaved? {
        for each in tasksFetched {
            if each.id == task.id {
                return each
            }
        }
        return nil
    }
}

//struct CardEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardEditView()
//    }
//}
