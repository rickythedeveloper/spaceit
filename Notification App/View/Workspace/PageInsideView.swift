//
//  PageInsideView.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 21/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct PageInsideView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Page.fetchRequest()) var pages: FetchedResults<Page>
    @FetchRequest(fetchRequest: TaskSaved.fetchRequest()) var tasks: FetchedResults<TaskSaved> // purely to refresh view when the TaskSaved entity is changed in CoreData. (e.g. task name change / isActive change)
    
    var pageID: UUID
    
    var isInSelectionMode: Bool = false
    var onSelection: ((Page) -> Void)?
    
    @State private var newPageName = ""
    @State private var moreActionSheeting = false
    @State private var editingPageName = false
    @State private var addingConcept = false
    
    var body: some View {
        VStack {
            
            (self.tasks.count == 0 ? EmptyView() : EmptyView()) // purely to refresh view when the TaskSaved entity is changed in CoreData. (e.g. task name change / isActive change)
            
            HStack {
                TextField("New Page Name", text: self.$newPageName, onCommit: {
                    UIApplication.shared.endEditing()
                })
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10.0)
                    .multilineTextAlignment(.center)
                
                Button(action: self.addPage) {
                    Image(systemName: "plus")
                }
                    .disabled(!self.newPageName.hasContent())
            }
                .font(.title)
                .padding()
                

            List {
                Section(header: Text("Pages")) {
                    ForEach(self.pages.childrenOfPage(id: self.pageID), id: \.self) { child in
                        NavigationLink(destination: PageInsideView(pageID: child.id, isInSelectionMode: self.isInSelectionMode, onSelection: self.dismissThisViewAndPassInfo(pageSelected:)).environment(\.managedObjectContext, self.managedObjectContext)) {
                            Text(child.name)
                        }
                    }.onDelete(perform: self.deleteChildren(at:))
                }
                
                Section(header: Text("Concepts")) {
                    ForEach(self.pages.conceptsOfPage(id: self.pageID), id: \.self) { concept in
                        NavigationLink(destination: CardEditView(task: concept).environment(\.managedObjectContext, self.managedObjectContext)) {
                            Text(concept.question)
                                .opacity(concept.isActive ? 1.0 : 0.5)
                        }
                    }//.onDelete(perform: self.deleteChildren(at:))
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            self.addingConcept = true
                        }) {
                            Image(systemName: "plus")
                                .imageScale(.large)
                                .multilineTextAlignment(.center)
                                .sheet(isPresented: self.$addingConcept) {
                                    AddSR(preChosenPage: self.pages.page(id: self.pageID)).environment(\.managedObjectContext, self.managedObjectContext)
                                }
                                .foregroundColor(.blue)
                        }
                        Spacer()
                    }
                }
            }
        }
        .navigationBarTitle(self.pages.page(id: self.pageID) != nil ? self.pages.page(id: self.pageID)!.name : "This Page Does Not Exist")
        .navigationBarItems(trailing: Button(action: self.morePressed) {
            if !self.isInSelectionMode {
                Image(systemName: "ellipsis")
                    .font(.title)
                    .actionSheet(isPresented: self.$moreActionSheeting) {
                        ActionSheet(title: Text("Action"), message: nil, buttons: [.cancel(), .default(Text("Edit page name"), action: self.editPageNamePressed)])
                    }
                    .sheet(isPresented: self.$editingPageName) {
                        PageNameEditView(pageID: self.pageID).environment(\.managedObjectContext, self.managedObjectContext)
                    }
            } else {
                Text("Choose")
                    .font(.title)
            }
            
        })
    }
    
    private func addPage() {
        guard let thisPage = self.pages.page(id: self.pageID) else {return}
        let newPage = Page.createPageInContext(name: self.newPageName, id: UUID(), context: self.managedObjectContext)
        thisPage.addToChildren(newPage)
        self.managedObjectContext.saveContext()
        self.newPageName = ""
        UIApplication.shared.endEditing()
    }
    
    private func deleteChildren(at indexSet: IndexSet) {
        for eachIndex in indexSet {
            self.managedObjectContext.delete(self.pages.childrenOfPage(id: self.pageID)[eachIndex])
        }
        self.managedObjectContext.saveContext()
    }
    
    private func morePressed() {
        if self.isInSelectionMode {
            self.presentationMode.wrappedValue.dismiss()
            guard let thisPage = self.pages.page(id: self.pageID) else {return}
            self.dismissThisViewAndPassInfo(pageSelected: thisPage)
        } else {
            self.moreActionSheeting = true
        }
    }
    
    private func dismissThisViewAndPassInfo(pageSelected: Page) {
        self.presentationMode.wrappedValue.dismiss()
        guard let onSelection = self.onSelection else {return}
        onSelection(pageSelected)
    }
    
    private func editPageNamePressed() {
        self.editingPageName = true
    }
    
//    private func deleteThisPage() {
//        self.managedObjectContext.delete(self.page)
//        self.managedObjectContext.saveContext()
//        self.updateParent.toggle()
//        self.presentationMode.wrappedValue.dismiss()
//    }
}
