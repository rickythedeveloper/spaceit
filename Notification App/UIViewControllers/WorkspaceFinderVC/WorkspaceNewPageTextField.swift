//
//  WorkspaceNewPageTextField.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 14/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import RickyFramework
import CoreData

class WorkspaceNewPageTextField: UITextField {
    
    unowned var finderTableView: FinderTableView
    
    init(finderTableView: FinderTableView) {
        self.finderTableView = finderTableView
        super.init(frame: .zero)
        
        setup()
    }
    
    deinit {
//        print("new page text field is being destroyed")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.usesAutolaoyut()
        let padding: CGFloat = 10.0
        self.backgroundColor = UIColor.tvBackground()
        self.font = UIFont.preferredFont(forTextStyle: .title2)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 1))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
        self.layer.cornerRadius = padding
        self.layer.masksToBounds = true
        self.textAlignment = .center
        self.placeholder = "New page"
        
        self.delegate = self
    }
}

extension WorkspaceNewPageTextField: UITextFieldDelegate {
    /// If the text has some content, add a child page.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        guard let page = finderTableView.information as? Page else {return true}
        guard let text = textField.text, text.hasContent() else {return true}
        addChildPage(to: page, text: text)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        addHorizontalKeyCommands()
    }
    
    /// Updates the information required for the keyboard guardian in workspace to work before the keyboard shows.
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let workspaceFinderVC = finderTableView.containerView?.finderVC as? WorkspaceFinderVC else {return true}
        workspaceFinderVC.updateKeyboardGuardianInformation(self, inside: self.finderTableView)
        self.removeHorizontalKeyCommands()
        return true
    }
    
    /// Add new page under this page if there is a text in the new page text field.
    private func addChildPage(to page: Page, text: String) {
        let managedObjectContext = NSManagedObjectContext.defaultContext()
        let newPage = Page.createPageInContext(name: text, context: managedObjectContext)
        page.addToChildren(newPage)
        managedObjectContext.saveContext(completion: {
            if let workspaceFinderVC = self.finderTableView.containerView?.finderVC as? WorkspaceFinderVC {
                workspaceFinderVC.reloadAllViews(completion: {
                    self.text = ""
                    
                })
            }
        })
    }
    
    private func addHorizontalKeyCommands() {
        guard let workspaceFinderVC = finderTableView.containerView?.finderVC as? WorkspaceFinderVC else {return}
        workspaceFinderVC.horizontalKeyCommandsEnabled = true
    }
    
    private func removeHorizontalKeyCommands() {
        guard let workspaceFinderVC = finderTableView.containerView?.finderVC as? WorkspaceFinderVC else {return}
        workspaceFinderVC.horizontalKeyCommandsEnabled = false
    }
}
