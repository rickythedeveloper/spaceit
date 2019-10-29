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
    var onSelection: ((Page) -> Void)? // after selecting a file location (e.g. when adding a page to a card)
    
    @State private var newPageName = ""
    @State private var moreActionSheeting = false
    @State private var editingPageName = false
    @State private var addingConcept = false
    
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)
    
    var body: some View {
        VStack {
            
            (self.tasks.count == 0 ? EmptyView() : EmptyView()) // purely to refresh view when the TaskSaved entity is changed in CoreData. (e.g. task name change / isActive change)

            List {
                Section(header: Text("Pages")) {
                    ForEach(self.pages.childrenOfPage(id: self.pageID), id: \.self) { child in
                        NavigationLink(destination: PageInsideView(pageID: child.id, isInSelectionMode: self.isInSelectionMode, onSelection: self.dismissThisViewAndPassInfo(pageSelected:)).environment(\.managedObjectContext, self.managedObjectContext)) {
                            HStack {
                                Text(child.name)
                                Spacer()
                                Text(String(child.nOfConceptsUnder()))
                                    .opacity(0.5)
                            }
                            
                        }
                    }.onDelete(perform: self.deleteChildren(at:))
                    
                    NewPageTF(newPageName: self.$newPageName, addPageAction: self.addPage, kGuardian: self.kGuardian)
                        
                }
                
                Section(header: Text("Concepts")) {
                    ForEach(self.pages.conceptsOfPage(id: self.pageID), id: \.self) { concept in
                        NavigationLink(destination: CardEditView(task: concept).environment(\.managedObjectContext, self.managedObjectContext)) {
                            pageCardCell(task: concept)
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
                                    AddSR(preChosenPage: self.thisPage()).environment(\.managedObjectContext, self.managedObjectContext)
                                }
                                .foregroundColor(.blue)
                        }
                        Spacer()
                    }
                }
            }.offset(y: self.kGuardian.slide).animation(.easeInOut(duration: 0.2))
        }
        .navigationBarTitle(self.pageName())
        .navigationBarItems(trailing: Button(action: self.morePressed) {
            if !self.isInSelectionMode {
                Image(systemName: "ellipsis")
                    .font(.title)
                    .popSheet(isPresented: self.$moreActionSheeting, arrowEdge: .top, content: { () -> PopSheet in
                        PopSheet.pageAction(title: self.pageName(), editName: self.editPageNamePressed, addHigherPage: self.addHigherPage, deleteTopPage: self.deleteTopPage, pageType: self.pageType())
                    })
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
        let newPage = Page.createPageInContext(name: self.newPageName, id: UUID(), context: self.managedObjectContext)
        if let thisPage = self.thisPage() {
            thisPage.addToChildren(newPage)
            self.managedObjectContext.saveContext()
        }
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
            self.dismissThisViewAndPassInfo(pageSelected: self.thisPage()!)
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
    
    private func deleteTopPage() {
        guard self.isTopPage() && self.onlyHasOneChild() else {return}
        
        if let thisPage = self.thisPage() {
            let onlyChild = (thisPage.children as! Set<Page>).first!
            thisPage.removeFromChildren(onlyChild)
            self.managedObjectContext.delete(thisPage)
            self.managedObjectContext.saveContext()
        }
    }
    
    private func addHigherPage() {
        guard self.isTopPage() else {return}
        
        let higherPage = Page.createPageInContext(name: "My workspace", id: UUID(), context: self.managedObjectContext)
        if let thisPage = self.thisPage() {
            thisPage.parent = higherPage
            self.managedObjectContext.saveContext()
        }
    }
    
    private func isTopPage() -> Bool {
        if let thisPage = self.thisPage() {
            return thisPage.topPage().id == self.pageID
        } else {
            return false
        }
    }
    
    private func onlyHasOneChild() -> Bool {
        if let thisPage = self.thisPage() {
            return thisPage.children?.count == 1
        } else {
            return false
        }
    }
    
    private func hasNoConcepts() -> Bool {
        if let thisPage = self.thisPage(), let concepts = thisPage.concepts {
            return concepts.count == 0
        } else {
            return true
        }
    }
    
    private func pageName() -> String {
        return (self.thisPage() != nil ? self.thisPage()!.name : "")
    }
    
    private func thisPage() -> Page? {
        return self.pages.page(id: self.pageID)
    }
    
    private func pageType() -> PageType {
        if self.isTopPage() && self.onlyHasOneChild() && self.hasNoConcepts() {
            return .topWithDeleteOption
        } else if self.isTopPage() {
            return .topWithoutDeleteOption
        } else {
            return .nonTop
        }
    }
    
//    private func deleteThisPage() {
//        self.managedObjectContext.delete(self.page)
//        self.managedObjectContext.saveContext()
//        self.updateParent.toggle()
//        self.presentationMode.wrappedValue.dismiss()
//    }
}
