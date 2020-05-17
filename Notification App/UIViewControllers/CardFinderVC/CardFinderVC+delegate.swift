//
//  CardFinderVC+delegate.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 16/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import RickyFramework

extension CardFinderVC: FinderVCDelegate {
    func finderTableView(_ tableView: FinderTableView, didSelectRowAt indexPath: IndexPath, isTouchInitiated: Bool) {
        guard indexPath.row < allTasks.count + 1 else {fatalError()}
        let task = allTasks[indexPath.row - 1]
        let cardEditVC = CardEditVC(task: task, managedObjectContext: managedObjectContext, onDismiss: {})
        let container = cardEditVC.newContainerView(finderVC: self)
        removeContainerViews(under: tableView.containerIndex() + 1)
        addContainerView(container)
        
        // If the width multiplier is one and the user has tapped a cell, then move the focus to the next container.
        // otherwise, keep the focus on the tapped container.
        if isTouchInitiated && containerTableWidthMultiplier == 1 && customViewWidthMultiplier == 1 {
            guard containerViews.count > tableView.containerIndex() + 1 else {fatalError()}
            self.highlightedContainerIndex = tableView.containerIndex() + 1 // This will set the highlight to the container view that has just been added.
        } else {
            self.highlightedContainerIndex = tableView.containerIndex() // This will set the highlight to the tapped table view.
        }
    }
    
    func finderTableView(_ tableView: FinderTableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row == 0 ? false : true
    }
    
    func finderViewController(highlightDidMoveTo containerView: FinderContainerView?) {
        if let container = containerView {
            let containerIndex = container.containerIndex()
            // If the width multiplier is less than 1 and there is another container to the trailing side of it, show the one ahead.
            // otherwise, show the focused container.
            if containerTableWidthMultiplier < 1 && customViewWidthMultiplier < 1 && containerIndex + 1 < containerViews.count {
                self.showContainerView(at: containerIndex + 1, on: .trailingSide, completion: {})
            } else {
                self.showContainerView(at: containerIndex, on: .trailingSide, completion: {})
            }
        }
        
        updateShortcutPermission(newContainerView: containerView)
    }
}

// MARK: highlight did move fucntions
extension CardFinderVC {
    private func updateShortcutPermission(newContainerView: FinderContainerView?) {
        for container in containerViews {
            if let cardEditVC = container.customViewController as? CardEditVC {
                cardEditVC.allowsKeyCommands = false
            } else if let newCardVC = container.customViewController as? NewCardVC {
                newCardVC.allowsKeyCommands = false
            }
        }
        
        if let containerView = newContainerView {
            if let cardEditVC = containerView.customViewController as? CardEditVC {
                self.horizontalKeyCommandsEnabled = false
                self.verticalKeyCommandsEnabled = false
                cardEditVC.allowsKeyCommands = true
            } else if let newCardVC = containerView.customViewController as? NewCardVC {
                self.horizontalKeyCommandsEnabled = false
                self.verticalKeyCommandsEnabled = false
                newCardVC.allowsKeyCommands = true
            } else {
                self.horizontalKeyCommandsEnabled = true
                self.verticalKeyCommandsEnabled = true
            }
        } else {
            self.horizontalKeyCommandsEnabled = true
            self.verticalKeyCommandsEnabled = true
        }
    }
}
