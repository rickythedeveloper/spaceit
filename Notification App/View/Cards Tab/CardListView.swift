//
//  CardListView.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 15/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct CardListView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: TaskSaved.fetchRequest()) var tasksFetched: FetchedResults<TaskSaved>
    
    @State private var listChoice = 0
    @State private var addingNewSR = false
    
    var body: some View {
        
        NavigationView {
            VStack {
                        
                Picker(selection: self.$listChoice, label: Text("choose")) {
                    Text("Upcoming").tag(0)
                    Text("All").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                
                
                if self.listChoice == 0 {
                    List {
                        ForEach(0..<self.justUpcoming().count, id: \.self) { index in
                            NavigationLink(destination: CardEditView(task: self.justUpcoming()[index]).environment(\.managedObjectContext, self.managedObjectContext), label: {
                                HStack {
                                    Text(self.justUpcoming()[index].question)
                                        .opacity(self.justUpcoming()[index].isActive ? 1.0 : 0.5)
                                    Spacer()
                                    Text(self.justUpcoming()[index].dueDateString())
                                        .foregroundColor(.gray)
                                }
                            })
                        }
                    }
                } else {
                    List {
                        ForEach(0..<self.allOfTasks().count, id: \.self) { index in
                            NavigationLink(destination:
                                CardEditView(task: self.allOfTasks()[index]).environment(\.managedObjectContext, self.managedObjectContext), label: {
                                Text(self.allOfTasks()[index].question)
                                    .opacity(self.allOfTasks()[index].isActive ? 1.0 : 0.5)
                            })
                        }
                    }
                }
            }.padding()
            .navigationBarTitle("Cards")
            .navigationBarItems(trailing:
                Button(action: {self.addingNewSR = true}) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.blue)
                        .sheet(isPresented: self.$addingNewSR, onDismiss: nil) {
                            AddSR().environment(\.managedObjectContext, self.managedObjectContext)
                        }
                }
            )
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func allOfTasks() -> [TaskSaved] {
        return self.tasksFetched.sortedByName()
    }
    
    private func justUpcoming() -> [TaskSaved] {
        return self.tasksFetched.sortedByDueDate().activeTasks()
    }
}

//struct CardListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardListView()
//    }
//}
