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
    @State private var allTasks = [TaskSaved]()
    @State private var upcomingTasks = [TaskSaved]()
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
                        ForEach(0..<self.upcomingTasks.count, id: \.self) { index in
                            NavigationLink(destination: CardEditView(task: self.upcomingTasks[index].convertToTask()).environment(\.managedObjectContext, self.managedObjectContext), label: {
                                HStack {
                                    Text(self.upcomingTasks[index].question)
                                    Spacer()
                                    Text(self.upcomingTasks[index].dueDateString())
                                        .foregroundColor(.gray)
                                }
                            })
                        }
                    }
                } else {
                    List {
                        ForEach(0..<self.allTasks.count, id: \.self) { index in
                            NavigationLink(destination:
                                CardEditView(task: self.allTasks[index].convertToTask()).environment(\.managedObjectContext, self.managedObjectContext), label: {
                                Text(self.allTasks[index].question)
                            })
                        }
                    }
                }
            }.padding()
            .onAppear(perform: {
                self.refresh()
            })
            .navigationBarTitle("Cards")
            .navigationBarItems(trailing:
                Button(action: {self.addingNewSR = true}) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.blue)
                        .sheet(isPresented: self.$addingNewSR, onDismiss: self.refresh) {
                            AddSR().environment(\.managedObjectContext, self.managedObjectContext)
                        }
                }
            )
        }
    }
    
    private func refresh() {
        self.sortAllObjectsByName()
        self.sortAllObjectsByDueDate()
    }
    
    private func sortAllObjectsByName() {
        self.allTasks = tasksFetched.sorted(by: { (lhs, rhs) -> Bool in
            if lhs.question < rhs.question {
                return true
            } else {
                return false
            }
        })
    }
    
    private func sortAllObjectsByDueDate() {
        var tasks = self.tasksFetched.sorted { (lhs, rhs) -> Bool in
            let lhsDue = lhs.lastChecked.addingTimeInterval(lhs.waitTime)
            let rhsDue = rhs.lastChecked.addingTimeInterval(rhs.waitTime)
            if lhsDue < rhsDue {
                return true
            } else {
                return false
            }
        }
        
//        MARK: Get only the ones that are active here...
        upcomingTasks = tasks
    }
}

//struct CardListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardListView()
//    }
//}
