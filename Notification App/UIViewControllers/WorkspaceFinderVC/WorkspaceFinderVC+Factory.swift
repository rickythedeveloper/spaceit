//
//  WorkspaceFinderVC+Factory.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import RickyFramework

extension WorkspaceFinderVC {
    func newContainerView(for page: Page) -> FinderContainerView {
        let tableView = FinderTableView(information: page)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: childPageCellID)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: newPageCellID)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: childCardCellID)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: newCardCellID)
        let container = FinderContainerView(finderTableView: tableView, navigationBar: nil, finderVC: self)
        let navigationBar = WorkspaceNavBar(workspaceFinderVC: self, containerView: container, workspaceAccessible: self.workspaceAccessible)
        container.navigationBar = navigationBar
        container.layout()
        return container
    }
    
    func showNewContainerViewForPage(after tableView: FinderTableView, didSelectAt indexPath: IndexPath) {
        guard let page = tableView.information as? Page, page.childrenArray().count > indexPath.row else {return}
        let containerIndex = tableView.containerIndex()
        let nextContainer = self.newContainerView(for: page.childrenArray().sortedByName()[indexPath.row])
        hideContainerView(at: containerIndex + 2, completion: {
            self.removeContainerViews(under: containerIndex + 1)
            self.addContainerView(nextContainer)
            self.showContainerView(nextContainer, on: .trailingSide, completion: {})
        })
    }
    
    func newContainerView(for card: TaskSaved) -> FinderContainerView {
        let cardEditVC = CardEditVC(task: card, managedObjectContext: self.managedObjectContext, onDismiss: {})
        let container = FinderContainerView(customViewController: cardEditVC, navigationBar: nil, finderVC: self)
        cardEditVC.finderContainerView = container
        container.navigationBar = WorkspaceNavBar(workspaceFinderVC: self, containerView: container, workspaceAccessible: self.workspaceAccessible)
        container.layout()
        return container
    }
    
    func showNewContainerForCard(after tableView: FinderTableView, didSelectAt indexPath: IndexPath) {
        guard let page = tableView.information as? Page, page.cardsArray().count > indexPath.row else {return}
        let containerIndex = tableView.containerIndex()
        let nextContainer = self.newContainerView(for: page.cardsArray().sortedByCreationDate(oldFirst: true)[indexPath.row])
        hideContainerView(at: containerIndex + 2, completion: {
            self.removeContainerViews(under: containerIndex + 1)
            self.addContainerView(nextContainer)
            self.showContainerView(nextContainer, on: .trailingSide, completion: {})
        })
    }
    
    func newContainerViewForNewCard(page: Page) -> FinderContainerView {
        let newCardVC = NewCardVC(prechosenPage: page)
        let navItem = UINavigationItem()
        let title = UILabel()
        title.text = "New Card"
        navItem.titleView = title
        let navBar = UINavigationBar()
        navBar.setItems([navItem], animated: true)
        let container = FinderContainerView(customViewController: newCardVC, navigationBar: navBar, finderVC: self)
        container.layout()
        return container
    }
    
    func shoeContainerForNewCard(after tableView: FinderTableView) {
        guard let page = tableView.information as? Page else {return}
        let containerIndex = tableView.containerIndex()
        let nextContainer = self.newContainerViewForNewCard(page: page)
        hideContainerView(at: containerIndex + 2, completion: {
            self.removeContainerViews(under: containerIndex + 1)
            self.addContainerView(nextContainer)
            self.showContainerView(nextContainer, on: .trailingSide, completion: {})
        })
    }
}
