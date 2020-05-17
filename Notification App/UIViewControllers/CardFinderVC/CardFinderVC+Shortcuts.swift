//
//  CardFinderVC+Shortcuts.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 17/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension CardFinderVC {
    override var keyCommands: [UIKeyCommand]? {
        var commands = [UIKeyCommand]()
        commands.append(contentsOf: super.keyCommands ?? [])
        commands.append(contentsOf: [
            UIKeyCommand(title: "New Card", action: #selector(newCardButtonTapped), input: "n", modifierFlags: [.command], discoverabilityTitle: "New Card"),
            UIKeyCommand(title: "Workspace Tab", action: #selector(moveToWorkspaceTab), input: UIKeyCommand.inputRightArrow, modifierFlags: [.command, .control, .alternate], discoverabilityTitle: "Workspace Tab"),
        ])
        return commands
    }
    
    @objc private func moveToWorkspaceTab() {
        self.tabBarController?.selectedIndex = 1
    }
}
