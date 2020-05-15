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
    func finderTableView(_ tableView: FinderTableView, didSelectRowAt indexPath: IndexPath, isTouchInitiated: Bool) {
//        print("did select")
        self.highlightedContainerIndex = tableView.containerIndex()
        if containerTableWidthMultiplier < 1 && customViewWidthMultiplier < 1 {
            self.didSelect(on: tableView, at: indexPath, isFullWidth: false)
        } else {
            self.didSelect(on: tableView, at: indexPath, isFullWidth: true, completion: {(nextContainerIndex) in
                guard let index = nextContainerIndex else {return}
                if isTouchInitiated {
                    self.highlightedContainerIndex = index
                }
            })
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
        guard let container = containerView else {return}
        if containerTableWidthMultiplier == 1 && customViewWidthMultiplier == 1 {
            self.showContainerView(container, on: .trailingSide, completion: {})
        }
        
        
        if let containerView = containerView {
            if let _ = containerView.customViewController as? CardEditVC {
                self.horizontalKeyCommandsEnabled = false
                self.verticalKeyCommandsEnabled = false
            } else if let _ = containerView.customViewController as? NewCardVC {
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

// MARK: Did select functions
extension WorkspaceFinderVC {
    /// Adds a next container view right next to the current container view. Depending on the isFullWidth value, decides whether to show the new container or not.
    private func didSelect(on tableView: FinderTableView, at indexPath: IndexPath, isFullWidth: Bool, completion: @escaping (_ nextContainerIndex: Int?) -> Void = {_ in}) {
        guard let page = tableView.information as? Page else {return}
        let containerIndex = tableView.containerIndex()
        var nextContainer: FinderContainerView?
        
        if indexPath.section == 0 && indexPath.row < page.numberOfChildren() {
            nextContainer = newChildPageContainerView(for: page, index: indexPath.row)
        } else if indexPath.section == 1 {
            if indexPath.row < page.numberOfCards() {
                nextContainer = newChildCardContainerView(for: page, index: indexPath.row)
            } else {
                nextContainer = self.newContainerViewForNewCard(under: page)
            }
        }
        
        if let nextContainer = nextContainer {
            isFullWidth ? addContainerViewAndStay(newContainerView: nextContainer, after: containerIndex) : addAndScrollTo(containerView: nextContainer, after: containerIndex)
            completion(containerIndex + 1)
        }
        completion(nil)
    }
    
    private func newChildPageContainerView(for page: Page, index: Int) -> FinderContainerView? {
        guard page.childrenArray().count > index else {return nil}
        let childPage = page.childrenArray()[index]
        return newContainerView(for: childPage)
    }
    
    private func newChildCardContainerView(for page: Page, index: Int) -> FinderContainerView? {
        guard page.cardsArray().count > index else {return nil}
        let childCard = page.cardsArray().sortedByCreationDate(oldFirst: true)[index]
        return newContainerView(for: childCard)
    }
    
    private func addContainerViewAndStay(newContainerView: FinderContainerView, after currentContainerIndex: Int) {
        hideContainerView(at: currentContainerIndex + 1, completion: {
            self.removeContainerViews(under: currentContainerIndex + 1)
            self.addContainerView(newContainerView)
        })
    }
    
    private func addAndScrollTo(containerView: FinderContainerView, after currentContainerIndex: Int) {
        hideContainerView(at: currentContainerIndex + 2, completion: {
            self.removeContainerViews(under: currentContainerIndex + 1)
            self.addContainerView(containerView)
            self.showContainerView(containerView, on: .trailingSide, completion: {})
        })
    }
}
