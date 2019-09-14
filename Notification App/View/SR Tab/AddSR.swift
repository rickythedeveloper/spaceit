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
            Spacer()
            Text("New spaced repetition")
                .font(.title)
            
            VStack {
                TextField("Question/Reminder", text: self.$question)
                TextField("Answer/Hint", text: self.$answer)
            }.padding()
            .font(.largeTitle)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                self.addButtonPressed()
            }) {
                Image(systemName: "plus.rectangle")
                    .imageScale(.large)
                    .font(.title)
            }
            
            Spacer()
            Text("The first reminder will be delivered in 24 hours.")
                .foregroundColor(.gray)
        }
            .padding()
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
//        task.waitTime = 5
        task.waitTime = 60*60*24
        
        self.saveContext()
        self.registerNotification(id: task.id, question: task.question, waitTime: task.waitTime)
        
        self.question = ""
        self.answer = ""
    }
    
    func saveContext() {
        do {
            try self.managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
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
}

struct AddSR_Previews: PreviewProvider {
    static var previews: some View {
        AddSR()
    }
}
