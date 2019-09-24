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
    
    var isInSelectionMode: Bool = false
    var onSelection: ((Page) -> Void)?
    
    let welcome = "Welcome to Workspace"
    let welcomeText = "If you haven't created your own workspace on any of your devices, start by tapping the plus button below!\n\nIf you already do have a workspace on a different iCloud-enabled device, then please wait for this device to load up the data..."
    
    var body: some View {
        NavigationView {
            
            if pages.count == 0 {
                VStack {
                    Text(self.welcome)
                        .font(.title)
                        .opacity(0.7)
                    Text(self.welcomeText)
                        .opacity(0.6)
                        .padding()
                    Button(action: self.addTopLevelWorkSpace) {
                        VStack {
                            Image(systemName: "plus")
                                .font(.largeTitle)
                                .imageScale(.large)
                            Text("Create workspace")
                                .font(.caption)
                        }
                        
                    }
                }.padding()
                
            } else {
                PageInsideView(pageID: self.topPageHandlingClashes()!.id, isInSelectionMode: self.isInSelectionMode, onSelection: self.onSelection).environment(\.managedObjectContext, self.managedObjectContext)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func addTopLevelWorkSpace() {
        _ = Page.createPageInContext(name: "My Workspace", id: UUID(), context: self.managedObjectContext)
        self.managedObjectContext.saveContext()
    }
    
    private func topPageHandlingClashes() -> Page? {
        guard self.pages.count > 0 else {return nil}
        
        var topPages = [Page]()
        for eachPageSaved in self.pages {
            var willAddToTopPages = true
            for eachTopPage in topPages {
                if eachPageSaved.topPage().id == eachTopPage.id {
                    willAddToTopPages = false
                }
            }
            if willAddToTopPages {
                topPages.append(eachPageSaved.topPage())
            }
        }
        
        if topPages.count == 1 {
            return topPages.first!
        } else {
            let newTopPage = Page.createPageInContext(name: "New workspace (merged)", id: UUID(), context: self.managedObjectContext)
            for eachOldTopPage in topPages {
                newTopPage.addToChildren(eachOldTopPage)
            }
            self.managedObjectContext.saveContext()
            return newTopPage
        }
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
