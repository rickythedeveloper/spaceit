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
    
    /// Updates the information required for the keyboard guardian to work. Call this just before the keyboard shows.
    func updateKeyboardGuardianInformation(_ textField: WorkspaceNewPageTextField, inside finderTableView: FinderTableView) {
        viewsToGuard = [textField]
        finderTableViewForTappedNewPageTextField = finderTableView
    }
    
    /// Will be called when the keyboard is about to show.
    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        if let changeInOffset = offsetDueToKeyboard(keyboardNotification: notification), let finderTableView = finderTableViewForTappedNewPageTextField {
            let finalOffset = CGPoint(x: 0, y: max(finderTableView.contentOffset.y + changeInOffset.y, 0))
            finderTableView.setContentOffset(finalOffset, animated: true)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setContainerWidth(viewWidth: size.width)
        updateContainerWidth()
    }
    
    func setContainerWidth(viewWidth: CGFloat) {
        if viewWidth < 500 {
            containerWidthMultiplier = 1
        } else if viewWidth < 800 {
            containerWidthMultiplier = 1/2
        } else if viewWidth < 1200{
            containerWidthMultiplier = 1/3
        } else {
            containerWidthMultiplier = 1/4
        }
    }
}
