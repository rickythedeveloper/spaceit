//
//  CardEditVC+Keyboard.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 21/06/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension CardEditVC {
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var keyCommands: [UIKeyCommand]? {
        var commands = [UIKeyCommand]()
        
        // Action for pressing tab
        var tabActionName: String
        if frontTextView.isFirstResponder {
            tabActionName = "Edit Back Text"
        } else if backTextView.isFirstResponder {
            tabActionName = "Edit Front Text"
        } else {
            tabActionName = "Edit Front Text"
        }
        commands.append(UIKeyCommand(title: tabActionName, image: nil, action: #selector(moveToNextTV), input: "\t", modifierFlags: [], propertyList: nil, alternates: [], discoverabilityTitle: tabActionName, attributes: [], state: .on))
        
        commands.append(contentsOf: [
            UIKeyCommand(title: "Select page", action: #selector(selectPage), input: "p", modifierFlags: [.command], discoverabilityTitle: "Select page"),
            UIKeyCommand(title: "Review: Very Hard", action: #selector(depressedAction), input: "1", modifierFlags: [.command], discoverabilityTitle: "Review: Very Hard"),
            UIKeyCommand(title: "Review: Hard", action: #selector(sadAction), input: "2", modifierFlags: [.command], discoverabilityTitle: "Review: Hard"),
            UIKeyCommand(title: "Review: Easy", action: #selector(okayAction), input: "3", modifierFlags: [.command], discoverabilityTitle: "Review: Easy"),
            UIKeyCommand(title: "Review: Very Easy", action: #selector(happyAction), input: "4", modifierFlags: [.command], discoverabilityTitle: "Review: Very Easy"),
        ])
        
        return commands
    }
    
    @objc private func moveToNextTV() {
        if frontTextView.isFirstResponder {
            backTextView.becomeFirstResponder()
        } else if backTextView.isFirstResponder {
            backTextView.resignFirstResponder()
        } else {
            frontTextView.becomeFirstResponder()
        }
    }
}
