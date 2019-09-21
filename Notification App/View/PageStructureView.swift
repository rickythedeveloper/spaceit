//
//  PageStructureView.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 21/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct PageStructureView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Page.fetchRequest()) var pages: FetchedResults<Page>
    
    var body: some View {
        NavigationView {
            
            if pages.count == 0 {
                Text("A")
            } else {
                PageInsideView(page: topPage()!).environment(\.managedObjectContext, self.managedObjectContext)
            }
        }.onAppear(perform: self.setup)
    }
    
    private func setup() {
        guard pages.count > 0 else {self.addTopLevelWorkSpace(); return}
    }
    
    private func addTopLevelWorkSpace() {
        let newPage = Page(context: managedObjectContext)
        newPage.name = "My Workspace"
        
        self.managedObjectContext.saveContext()
    }
    
    private func topPage() -> Page? {
        guard pages.count > 0 else {return nil}
        return topPage(of: self.pages[0])
    }
    
    private func topPage(of page: Page) -> Page {
        if let parent = page.parent {
            return topPage(of: parent)
        } else {
            return page
        }
    }
}

//struct PageStructure_Previews: PreviewProvider {
//    static var previews: some View {
//        PageStructureView()
//    }
//}
