//
//  UIAlertController+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 07/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension UIAlertController {
    public static func noContentAlert() -> UIAlertController {
        let ac = UIAlertController(title: "Invalid front text", message: "Please enter text for the front", preferredStyle: .alert)
        ac.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        return ac
    }
    
    public static func saveFailedAlert() -> UIAlertController {
        let ac = UIAlertController(title: "Save failed", message: "Do you want to exit anyway?", preferredStyle: .alert)
        ac.addAction(UIAlertAction.init(title: "Exit", style: .default, handler: nil))
        ac.addAction(UIAlertAction.init(title: "Stay on this card", style: .cancel, handler: nil))
        return ac
    }
    
    static func deleteAlert(action: @escaping ()->Void) -> UIAlertController {
        let ac = UIAlertController(title: "Delete card?", message: "This action cannot be undone", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            action()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return ac
    }
    
    static func archiveAlert(action: @escaping ()->Void) -> UIAlertController {
        let ac = UIAlertController(title: "Archive card?", message: "You will be able to recover the card later", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Archive", style: .default, handler: { _ in
            action()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return ac
    }
    
    static func recoverAlert(action: @escaping ()->Void) -> UIAlertController {
        let ac = UIAlertController(title: "Recover card?", message: "You will be able to archive the card later", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Recover", style: .default, handler: { _ in
            action()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return ac
    }
    
    static func discardChangesAlert(action: @escaping ()->Void) -> UIAlertController {
        let ac = UIAlertController(title: "Discard changes?", message: "This card will be reverted back to its saved state", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { _ in
            action()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return ac
    }
    
    static func workspaceActionSheet(title: String, actions: [(title: String, style: UIAlertAction.Style, action: ()->Void)]) -> UIAlertController {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        for each in actions {
            ac.addAction(UIAlertAction(title: each.title, style: each.style, handler: { (_) in
                each.action()
            }))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return ac
    }
    
    static func editPageNameAlert(textFieldDelegate: WorkspaceVC, pageName: String, doneAction: @escaping (_ text: String)->Void, cancelAction: @escaping ()->Void) -> UIAlertController {
        let ac = UIAlertController(title: "Edit name", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = pageName
            textField.text = pageName
            textField.addTarget(textFieldDelegate, action: #selector(textFieldDelegate.nameEditingChanged(_:)), for: .editingChanged)
        }
        ac.addAction(UIAlertAction(title: "Done", style: .default, handler: { (_) in
            if let newName = ac.textFields?.first!.text, newName.hasContent() {
                doneAction(newName)
            } else {
                cancelAction()
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            cancelAction()
        }))

        return ac
    }
    
    static func editPageNameAlert(textFieldDelegate: WorkspaceNavBar, pageName: String, doneAction: @escaping (_ text: String)->Void, cancelAction: @escaping ()->Void) -> UIAlertController {
        let ac = UIAlertController(title: "Edit name", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = pageName
            textField.text = pageName
            textField.addTarget(textFieldDelegate, action: #selector(textFieldDelegate.nameEditingChanged(_:)), for: .editingChanged)
        }
        ac.addAction(UIAlertAction(title: "Done", style: .default, handler: { (_) in
            if let newName = ac.textFields?.first!.text, newName.hasContent() {
                doneAction(newName)
            } else {
                cancelAction()
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            cancelAction()
        }))

        return ac
    }
    
    static func noWorkspaceAlert(createPage: @escaping ()->Void) -> UIAlertController {
        let title = "Are you new here?"
        let message = "If you are a new customer, go ahead and tap Yes to create a new workspace! If you are an existing customer and you have your workspace on another device, please tap No and wait up to a few minutes to load."
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yes = UIAlertAction(title: "Yes", style: .default) { (_) in
            createPage()
        }
        ac.addAction(no)
        ac.addAction(yes)
        return ac
    }
    
    static func cannotMovePage() -> UIAlertController {
        let title = "Could not move page"
        let message = "You cannot move a page into somewhere that's directly below the page itself."
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(ok)
        return ac
    }
}
