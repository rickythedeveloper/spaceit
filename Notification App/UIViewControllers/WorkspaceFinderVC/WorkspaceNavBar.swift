//
//  WorkspacePageNavBar.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import RickyFramework

class WorkspaceNavBar: UINavigationBar, WorkspaceAccessible {
    var chosenPage: Page? { // WorkspaceAccessible requirement
        willSet {
            if let newParent = newValue {
                self.moveThisPageUnder(newParent)
            }
        }
    }
    var finderWorkspaceVC: WorkspaceFinderVC
    unowned var containerView: FinderContainerView
    var pageForTableView: Page?
    var workspaceAccessible: WorkspaceAccessible?
    
    init(finderWorkspaceVC: WorkspaceFinderVC, containerView: FinderContainerView, workspaceAccessible: WorkspaceAccessible?) {
        self.finderWorkspaceVC = finderWorkspaceVC
        self.containerView = containerView
        self.workspaceAccessible = workspaceAccessible
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Workspace Nav Bar is being destroyed")
    }
    
    func setup() {
        if let tableView = containerView.finderTableView {
            guard let page = tableView.information as? Page else {return}
            self.pageForTableView = page
            let navItem = UINavigationItem()
            let pageName = UILabel()
            pageName.text = page.name
            navItem.titleView = pageName
            
            var rightButton: UIBarButtonItem
            if workspaceAccessible == nil {
                rightButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(optionPressed))
            } else {
                rightButton = UIBarButtonItem(image: UIImage(systemName: "checkmark.circle"), style: .plain, target: self, action: #selector(selectThisPage))
            }
            navItem.rightBarButtonItem = rightButton
            
            if !page.isTopPage() {
                let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(dismissContainerView))
                navItem.leftBarButtonItem = backButton
            }
            
            self.setItems([navItem], animated: true)
        } else if let cardEditVC = containerView.customViewController as? CardEditVC {
            let navItem = UINavigationItem()
            let title = UILabel()
            title.text = "Edit Card"
            navItem.titleView = title
            navItem.rightBarButtonItems = [cardEditVC.deleteButtonItem(), cardEditVC.archiveButtonItem(), cardEditVC.discardChangesButtonItem()]
            self.setItems([navItem], animated: true)
        }
    }
    
    private func setTitle(_ text: String) {
        guard let titleLabel = items?.first?.titleView as? UILabel else {return}
        titleLabel.text = text
        titleLabel.sizeToFit()
    }
}

// MARK: Options pressed
extension WorkspaceNavBar {
    /// shows all the possible actions related to this page on an alert.
    @objc func optionPressed() {
        guard let page = pageForTableView else {return}
        var actions = [(String, UIAlertAction.Style, ()->Void)]()
        
        actions.append(("Edit name", UIAlertAction.Style.default, {
            self.editPageName(page: page)
        }))

        if page.isTopPage() == false {
            actions.append(("Move page", .default, {
                self.choosePageToMoveTo()
            }))
        }
//
        if page.isTopPage() == false {
            actions.append(("Delete page", UIAlertAction.Style.destructive, {
                self.deleteThisPage()
            }))
        }
        
        let ac = UIAlertController.workspaceActionSheet(title: page.name, actions: actions)
        if let popoverController = ac.popoverPresentationController {
            popoverController.barButtonItem = self.items?.first?.rightBarButtonItem
        }
        self.finderWorkspaceVC.present(ac, animated: true, completion: nil)
    }
    
    /// Shows an alert with a textfield so that the user can edit the page name.
    private func editPageName(page: Page) {
        let ac = UIAlertController.editPageNameAlert(textFieldDelegate: self, pageName: page.name, doneAction: { (newName) in
            page.name = newName
            self.finderWorkspaceVC.managedObjectContext.saveContext()
            self.setTitle(page.name)
        }, cancelAction: {
            self.setTitle(page.name)
        })
        
        self.finderWorkspaceVC.present(ac, animated: true, completion: nil)
    }
    
    
    private func choosePageToMoveTo() {
        self.finderWorkspaceVC.present(FinderWorkspaceVC(workspaceAccessible: self), animated: true, completion: nil)
    }
    
    /// If this page is not the top page, delete this page and save the core data context.
    private func deleteThisPage() {
        guard let thisPage = self.pageForTableView, !thisPage.isTopPage() else {fatalError()}
        
        self.containerView.dismiss(completion: {
            self.finderWorkspaceVC.managedObjectContext.delete(thisPage)
            self.finderWorkspaceVC.managedObjectContext.saveContext()
        })
    }
}

// MARK: Further option actions
extension WorkspaceNavBar {
    /// This function keeps the title of this navigation bar up to date with the text field.
    @objc func nameEditingChanged(_ textField: UITextField) {
        guard let text = textField.text else {return}
        setTitle(text)
    }
    
    /// This function should be called once the new parent page has been selected.
    private func moveThisPageUnder(_ newParent: Page) {
        guard let thisPage = self.pageForTableView else {return}
        
        thisPage.moveTo(under: newParent, cannotMoveAction: {
            DispatchQueue.main.async {
                self.finderWorkspaceVC.present(UIAlertController.cannotMovePage(), animated: true, completion: nil)
            }
        })
        self.finderWorkspaceVC.managedObjectContext.saveContext()
    }
    
    @objc private func dismissContainerView() {
        self.containerView.dismiss()
    }
}

// MARK: Nav bar inside a workspace that has been accessed by a different view
extension WorkspaceNavBar {
    @objc private func selectThisPage() {
        guard let thisPage = self.pageForTableView, self.workspaceAccessible != nil else {return}
        self.workspaceAccessible?.chosenPage = thisPage
        self.finderWorkspaceVC.dismiss(animated: true, completion: nil)
    }
}
