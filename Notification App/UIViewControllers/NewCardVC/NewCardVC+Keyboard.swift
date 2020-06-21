//
//  NewCardVC+Keyboard.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 21/06/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension NewCardVC {
    override var keyCommands: [UIKeyCommand]? {
        var commands = [UIKeyCommand]()
        
        // Action for pressing tab
        var tabActionName: String
        if frontTV.isFirstResponder {
            tabActionName = "Edit Back Text"
        } else if backTV.isFirstResponder {
            tabActionName = "Add Card"
        } else {
            tabActionName = "Edit Front Text"
        }
        commands.append(UIKeyCommand(title: tabActionName, image: nil, action: #selector(moveToNextTF), input: "\t", modifierFlags: [], propertyList: nil, alternates: [], discoverabilityTitle: tabActionName, attributes: [], state: .on))
        
        // Select page
        commands.append(UIKeyCommand(title: "Select Page for Card", image: nil, action: #selector(addPagePressed), input: "p", modifierFlags: [.command], propertyList: nil, alternates: [], discoverabilityTitle: "Select Page for Card", attributes: [], state: .on))
        
        return commands
    }
    
    @objc private func moveToNextTF() {
        if frontTV.isFirstResponder {
            // Move to back tv
            backTV.becomeFirstResponder()
        } else if backTV.isFirstResponder {
            // Add card
            self.addButtonPressed()
        } else {
            // Move to front tv
            frontTV.becomeFirstResponder()
        }
    }
    
    @objc private func moveToPrevuousTV() {
        if backTV.isFirstResponder {
            frontTV.becomeFirstResponder()
        } else {
            backTV.becomeFirstResponder()
        }
    }
}
