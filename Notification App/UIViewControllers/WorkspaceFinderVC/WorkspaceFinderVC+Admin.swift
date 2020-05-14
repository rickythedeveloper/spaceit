//
//  WorkspaceFinderVC+Admin.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import RickyFramework

extension WorkspaceFinderVC {
    
    /// Called when core data objects have changed.
    @objc func coreDataObjectsDidChange() {
        reloadAllViews(completion: {})
    }
    
    /// Reloads tabe view data and container width.
    func reloadAllViews(completion: () -> Void) {
        let pages = Array.pagesFetched(managedObjectContext: managedObjectContext)
        if pages.count == 0 {
            showNoPageAlert()
        } else {
            if topPage == nil {
                findTopPageAndAssignToThisPage(pages: pages)
                guard let topPage = topPage else {return}
                self.addContainerView(self.newContainerView(for: topPage))
            }
            
            DispatchQueue.main.async {
                self.updateContainerWidth()
                self.reloadAllContainerTableViews()
            }
            self.noWorkspaceAlert?.dismiss(animated: true, completion: nil)
        }
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
        self.reloadAllViews(completion: {})
    }
}
