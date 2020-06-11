//
//  WorkspaceColumnVC+Options.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 09/06/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

// MARK: Options pressed
extension WorkspaceColumnVC {
    func setupNavigationBar() {
        if columnIndex > 0 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonPressed))
        }
        if workspaceAccessible != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(selectThisPageForWorkspaceAccessible))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(optionPressed))
        }
        self.setTitle((tableView.information as? Page)?.name)
        navigationController?.navigationBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navTitlePressed)))
        
        navigationController?.navigationBar.barTintColor = .myBackGroundColor()
    }
    
    func setupTabBar() {
        tabBarController?.tabBar.barTintColor = .myBackGroundColor()
    }
    
    @objc private func backButtonPressed() {
        guard columnIndex > 0 else {fatalError()}
        self.workspaceViewController.hideColumn(at: self.columnIndex, on: .trailingSide, completion: {
            self.workspaceViewController.removeColumn(under: self.columnIndex, animationDuration: 0, completion: {})
        })
    }
    
    @objc private func navTitlePressed() {
        guard let page = tableView.information as? Page else {fatalError()}
        editPageName(page: page)
    }
    
    @objc private func selectThisPageForWorkspaceAccessible() {
        guard workspaceAccessible != nil else {fatalError()}
        guard let page = tableView.information as? Page else {fatalError()}
        self.workspaceViewController.dismiss(animated: true, completion: {
            self.workspaceAccessible?.chosenPage = page
        })
    }
    
    /// shows all the possible actions related to this page on an alert.
    @objc private func optionPressed() {
        guard let page = tableView.information as? Page else {fatalError()}
        guard workspaceAccessible == nil else {fatalError()}
        var actions = [(String, UIAlertAction.Style, ()->Void)]()
        
        actions.append(("Edit name", UIAlertAction.Style.default, {
            self.editPageName(page: page)
        }))
        
        if page.isTopPage() == false {
            actions.append(("Move page", .default, {
                self.choosePageToMoveTo()
            }))
            
            actions.append(("Delete page", UIAlertAction.Style.destructive, {
                self.deleteThisPage()
            }))
        }
        
        let ac = UIAlertController.workspaceActionSheet(title: page.name, actions: actions)
        if let popoverController = ac.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }
        self.workspaceViewController.present(ac, animated: true, completion: nil)
    }
    
    @objc private func navBarTouched() {
        guard let page = tableView.information as? Page else {fatalError()}
        editPageName(page: page)
    }
}

extension WorkspaceColumnVC {
    /// Shows an alert with a textfield so that the user can edit the page name.
    private func editPageName(page: Page) {
        let ac = UIAlertController.editPageNameAlert(textFieldDelegate: self, pageName: page.name, doneAction: { (newName) in
            page.name = newName
            self.workspaceViewController.managedObjectContext.saveContext()
            self.setTitle(page.name)
        }, cancelAction: {
            self.setTitle(page.name)
        })
        
        self.workspaceViewController.present(ac, animated: true, completion: nil)
    }
    
    
    private func choosePageToMoveTo() {
        guard workspaceAccessible == nil else {fatalError()}
        self.present(WorkspaceViewController(workspaceAccessible: self), animated: true, completion: nil)
    }
    
    /// If this page is not the top page, delete this page and save the core data context.
    private func deleteThisPage() {
        guard let page = tableView.information as? Page, !page.isTopPage() else {fatalError()}
        
        self.workspaceColumn.dismiss(hidesFirst: true, removalDuration: 0, completion: {
            self.workspaceViewController.managedObjectContext.delete(page)
            self.workspaceViewController.managedObjectContext.saveContext()
        })
    }
    
    /// This function keeps the title of this navigation bar up to date with the text field.
    @objc func nameEditingChanged(_ textField: UITextField) {
        guard let text = textField.text else {return}
        setTitle(text)
    }
    
    /// This function should be called once the new parent page has been selected.
    func moveThisPageUnder(_ newParent: Page) {
        guard let page = tableView.information as? Page else {fatalError()}

        page.moveTo(under: newParent, cannotMoveAction: {
            DispatchQueue.main.async {
                self.present(UIAlertController.cannotMovePage(), animated: true, completion: nil)
            }
        })
        managedObjectContext.saveContext()
    }
}
