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
    @State private var searchPhrase = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                        
                Picker(selection: self.$listChoice.animation(.easeInOut(duration: 0.7)), label: Text("choose")) {
                    Text("Upcoming").tag(0)
                    Text("Alphabetical").tag(1)
                    Text("Creation History").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
                
                TextField("Search", text: self.$searchPhrase)
                    .padding([.horizontal])
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10.0)
                    .modifier(ClearButton(text: self.$searchPhrase))
                
                if self.listChoice == 0 {
                    List {
                        ForEach(0..<self.justUpcoming().count, id: \.self) { index in
                            NavigationLink(destination: CardEditView(task: self.justUpcoming()[index]).environment(\.managedObjectContext, self.managedObjectContext), label: {
                                UpcomingCell(task: self.justUpcoming()[index], isFirst: index == 0)
                            })
                        }
                    }
                } else if self.listChoice == 1 {
                    List {
                        ForEach(0..<self.allOfTasks().count, id: \.self) { index in
                            NavigationLink(destination:
                                CardEditView(task: self.allOfTasks()[index]).environment(\.managedObjectContext, self.managedObjectContext), label: {
                                    allTaskCell(task: self.allOfTasks()[index])
                            })
                        }
                    }
                } else {
                    List {
                        ForEach(0..<self.tasksByCreationDate().count, id: \.self) { index in
                            NavigationLink(destination: CardEditView(task: self.tasksByCreationDate()[index]).environment(\.managedObjectContext, self.managedObjectContext), label: {
                                    creationHistoryCell(task: self.tasksByCreationDate()[index], isFirst: index == 0)
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
        if self.searchPhrase.hasContent() {
            return self.tasksFetched.sortedByName().filterByWord(searchPhrase: self.searchPhrase)
        } else {
            return self.tasksFetched.sortedByName()
        }
    }
    
    private func justUpcoming() -> [TaskSaved] {
        if self.searchPhrase.hasContent() {
            return self.tasksFetched.sortedByDueDate().activeTasks().filterByWord(searchPhrase: self.searchPhrase)
        } else {
            return self.tasksFetched.sortedByDueDate().activeTasks()
        }
    }
    
    private func tasksByCreationDate() -> [TaskSaved] {
        if self.searchPhrase.hasContent() {
            return self.tasksFetched.sortedByCreationDate(newFirst: true).filterByWord(searchPhrase: self.searchPhrase)
        } else {
            return self.tasksFetched.sortedByCreationDate(newFirst: true)
        }
    }
}

//struct CardListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardListView()
//    }
//}
