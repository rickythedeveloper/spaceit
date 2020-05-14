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
    
    func finderViewController(highlightDidMoveTo containerView: FinderContainerView, forward: Bool) {
    }
}
