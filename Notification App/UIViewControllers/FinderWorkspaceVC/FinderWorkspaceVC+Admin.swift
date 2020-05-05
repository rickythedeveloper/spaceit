//
//  FinderWorkspaceVC+Admin.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 04/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

// MARK: Reloading data and views
extension FinderWorkspaceVC {
    func standardReloadProcedure() {
        let pages = fetchPages()
        if pages.count == 0 {
            showNoPageAlert()
        } else {
            if topPage == nil {
                findTopPageAndAssignToThisPage(pages: pages)
            }
            reloadViews(reloadsTableViews: true)
            self.noWorkspaceAlert?.dismiss(animated: true, completion: nil)
        }
    }
    
    /// Fetch all the pages in the core data
    private func fetchPages() -> [Page] {
        return Array.pagesFetched(managedObjectContext: managedObjectContext)
    }
    
    /// GIven an array of pages, this function finds the top page whilst handling clashes and then assifns the top page to this page.
    private func findTopPageAndAssignToThisPage(pages: [Page]) {
        guard pages.count > 0 else {fatalError("The number of pages is 0 where it should not be")}
        if let topPage = pages.topPageHandlingClashes(managedObjectContext: managedObjectContext) {
            self.topPage = topPage
        } else {
            fatalError()
        }
    }
    
    /// Show alert asking if the user wants to create a page.
    private func showNoPageAlert() {
        noWorkspaceAlert = UIAlertController.noWorkspaceAlert(createPage: self.noPageSetup)
        self.present(noWorkspaceAlert!, animated: true, completion: nil)
    }
    
    private func noPageSetup() {
        self.topPage = Page.createPageInContext(name: "My Workspace", id: UUID(), context: self.managedObjectContext)
        self.managedObjectContext.saveContext()
        self.standardReloadProcedure()
    }
    
    func addChildPage(for page: Page, name: String, completion: @escaping () -> Void = {}) {
        guard name.hasContent() else {return}
        let newPage = Page.createPageInContext(name: name, context: self.managedObjectContext)
        page.addToChildren(newPage)
        self.managedObjectContext.saveContext(completion: {
            completion()
        })
    }
}
