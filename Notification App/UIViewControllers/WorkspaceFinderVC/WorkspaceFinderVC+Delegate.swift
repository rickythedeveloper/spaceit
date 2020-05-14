//
//  WorkspaceFinderVC+Delegate.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import RickyFramework

extension WorkspaceFinderVC: FinderVCDelegate {
//    TODO
    func finderTableView(_ tableView: FinderTableView, didSelectRowAt indexPath: IndexPath) {
//        print("did select")
        guard let page = tableView.information as? Page else {return}
        
        if indexPath.section == 0 && indexPath.row < page.numberOfChildren() {
            self.showNewContainerViewForPage(after: tableView, didSelectAt: indexPath)
        } else if indexPath.section == 1 {
            if indexPath.row < page.numberOfCards() {
                self.showNewContainerForCard(after: tableView, didSelectAt: indexPath)
            } else {
                self.shoeContainerForNewCard(after: tableView)
            }
        }
    }
    
    func findeeTableView(_ tableView: FinderTableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        print("will select")
        return indexPath
    }
    
    func finderTableView(_ tableView: FinderTableView, didDeselectRowAt indexPath: IndexPath) {
//        print("did deselect")
        return
    }
    
    func finderTableView(_ tableView: FinderTableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        print("should highlight")
        guard let page = tableView.information as? Page else {return true}
        if indexPath.section == 0 && indexPath.row == page.numberOfChildren() {
            return false
        }
        return true
    }
    
    func finderViewController(highlightDidMoveTo containerView: FinderContainerView?) {
        // Enable/disable shortcuts for FinderVC
        if let containerView = containerView {
            if let cardEditVC = containerView.customViewController as? CardEditVC {
                cardEditVC.frontTextView.becomeFirstResponder()
                self.horizontalKeyCommandsEnabled = false
                self.verticalKeyCommandsEnabled = false
            } else if let newCardVC = containerView.customViewController as? NewCardVC {
                newCardVC.frontTV.becomeFirstResponder()
                self.horizontalKeyCommandsEnabled = false
                self.verticalKeyCommandsEnabled = false
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
