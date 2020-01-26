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
}
