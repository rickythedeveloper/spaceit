//
//  AddSR.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 14/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct AddSR: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var question: String = ""
    @State private var answer: String = ""
    var body: some View {
        VStack {
            VStack {
                TextField("Question/Reminder", text: self.$question)
                TextField("Answer/Hint", text: self.$answer)
            }.padding()
            
            Button(action: {
                self.addButtonPressed()
            }) {
                Image(systemName: "plus.rectangle")
                    .imageScale(.large)
            }
        }
            .padding()
            .font(.largeTitle)
            .multilineTextAlignment(.center)
    }
    
    private func addButtonPressed() {
        let task = TaskSaved(context: self.managedObjectContext)
        task.id = UUID()
        task.question = self.question
        
        if self.answer == "" {
            task.answer = nil
        } else {
            task.answer = self.answer
        }
        
        task.lastChecked = Date()
        task.waitTime = 5
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Oh no couldnt save!!")
            print(error)
        }
        
        self.question = ""
        self.answer = ""
    }
}

struct AddSR_Previews: PreviewProvider {
    static var previews: some View {
        AddSR()
    }
}
