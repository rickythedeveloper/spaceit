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
    
    @State var question = ""
    @State var answer = ""
    
    var body: some View {
        VStack {
            Spacer()
            Text("Edit card")
                .font(.title)
            
            Group {
                TextField("Question/Reminder", text: self.$question)
                TextField("Answer/Hint", text: self.$answer)
            }.padding()
            .font(.largeTitle)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                self.updateData()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "checkmark")
                    .imageScale(.large)
            }
            
            Spacer()
        }
        .padding()
        .multilineTextAlignment(.center)
        .onAppear(perform: self.setup)
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
