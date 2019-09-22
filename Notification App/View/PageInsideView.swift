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
    
    var pageID: UUID
    
    @State private var newPageName = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("New Page Name", text: self.$newPageName, onCommit: {
                    UIApplication.shared.endEditing()
                })
                    .background(Color.gray)
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
                    
                    ForEach(self.children(), id: \.self) { child in
                        NavigationLink(destination: PageInsideView(pageID: child.id).environment(\.managedObjectContext, self.managedObjectContext)) {
                            Text(child.name)
                        }
                    }.onDelete(perform: self.deleteChildren(at:))
                }

//                Section(header: Text("Concepts")) {
//                    ForEach(self.page.concepts?.allObjects as! [TaskSaved], id: \.self) { concept in
//                        NavigationLink(destination: CardEditView(task: concept.convertToTask()).environment(\.managedObjectContext, self.managedObjectContext)) {
//                            Text(concept.question)
//                        }
//                    }
//                }
            }
        }
        .navigationBarTitle(self.thisPage() != nil ? self.thisPage()!.name : "This Page Does Not Exist")
    }
    
    private func thisPage() -> Page? {
        let possiblePages = self.pages.filter { (page) -> Bool in
            if page.id == self.pageID {return true} else {return false}
            }
        guard possiblePages.count == 1 else {return nil}
        return possiblePages[0]
    }
    
    private func children() -> [Page] {
        if let thisPage = self.thisPage() {
            let children = (thisPage.children?.allObjects as! [Page]).sortedByName()
            return children
        } else {
            return []
        }
        
    }
    
    private func addPage() {
        guard self.thisPage() != nil else {return}
        let newPage = Page.createPageInContext(name: self.newPageName, id: UUID(), context: self.managedObjectContext)
        self.thisPage()!.addToChildren(newPage)
        self.managedObjectContext.saveContext()
        self.newPageName = ""
        UIApplication.shared.endEditing()
    }
    
    private func deleteChildren(at indexSet: IndexSet) {
        for eachIndex in indexSet {
            self.managedObjectContext.delete(self.children()[eachIndex])
        }
        self.managedObjectContext.saveContext()
    }
    
//    private func deleteThisPage() {
//        self.managedObjectContext.delete(self.page)
//        self.managedObjectContext.saveContext()
//        self.updateParent.toggle()
//        self.presentationMode.wrappedValue.dismiss()
//    }
}
