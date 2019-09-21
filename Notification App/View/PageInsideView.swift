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
//    @FetchRequest(fetchRequest: Page.fetchRequest()) var pages: FetchedResults<Page>
    
    var page: Page
    
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
                    
                    ForEach((self.page.children?.allObjects as! [Page]).sorted(by: { (lhs, rhs) -> Bool in
                        if lhs.name < rhs.name {
                            return true
                        } else {
                            return false
                        }
                    }), id: \.self) { child in
                        NavigationLink(destination: PageInsideView(page: child).environment(\.managedObjectContext, self.managedObjectContext)) {
                            Text(child.name)
                        }
                    }
                }

                Section(header: Text("Concepts")) {
                    ForEach(self.page.concepts?.allObjects as! [TaskSaved], id: \.self) { concept in
                        NavigationLink(destination: CardEditView(task: concept.convertToTask()).environment(\.managedObjectContext, self.managedObjectContext)) {
                            Text(concept.question)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(self.page.name)
    }
    
    private func addPage() {
        let newPage = Page(context: managedObjectContext)
        newPage.name = self.newPageName
        self.page.addToChildren(newPage)
        self.managedObjectContext.saveContext()
        self.newPageName = ""
        UIApplication.shared.endEditing()
    }
    
//    private func deleteThisPage() {
//        self.managedObjectContext.delete(self.page)
//        self.managedObjectContext.saveContext()
//        self.updateParent.toggle()
//        self.presentationMode.wrappedValue.dismiss()
//    }
}

//struct PageInsideView_Previews: PreviewProvider {
//    static var previews: some View {
//        PageInsideView()
//    }
//}
