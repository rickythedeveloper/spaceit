//
//  WorkspaceFinderVC+Shortcuts.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 15/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension WorkspaceFinderVC {
    override var keyCommands: [UIKeyCommand]? {
        var commands = [UIKeyCommand]()
        commands.append(contentsOf: super.keyCommands ?? [])
        
        commands.append(contentsOf: [
            UIKeyCommand(title: "New Page", action: #selector(newPageShortcutPressed), input: "p", modifierFlags: [.command], discoverabilityTitle: "New Page"),
            UIKeyCommand(title: "New Card", action: #selector(newCardShortcutPressed), input: "n", modifierFlags: [.command], discoverabilityTitle: "New Card"),
            UIKeyCommand(title: "Cards", action: #selector(goToCardsListShortcutPressed), input: UIKeyCommand.inputLeftArrow, modifierFlags: [.command, .control, .alternate], discoverabilityTitle: "Cards Tab"),
        ])
        
        return commands
    }
    
    @objc func newPageShortcutPressed() {
        if let containerIndex = self.highlightedContainerIndex {
            guard containerIndex >= 0 && containerIndex < containerViews.count else {return}
            guard let newPageTextField = newPageTextField(for: containerViews[containerIndex]) else {return}
            newPageTextField.becomeFirstResponder()
        } else {
            guard containerViews.count > 0 else {return}
            guard let newPageTextField = newPageTextField(for: containerViews[0]) else {return}
            newPageTextField.becomeFirstResponder()
        }
    }
    
    @objc func newCardShortcutPressed() {
        self.selectNewCardCellOfHighlightedContainer()
    }
    
    @objc func goToCardsListShortcutPressed() {
        self.tabBarController?.selectedIndex = 0
    }
}
