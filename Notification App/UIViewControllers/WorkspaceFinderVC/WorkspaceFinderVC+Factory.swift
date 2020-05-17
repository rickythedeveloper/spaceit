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
        container.backgroundColor = .myBackGroundColor()
        container.layout()
        return container
    }
    
    func newContainerView(for card: TaskSaved) -> FinderContainerView {
        let cardEditVC = CardEditVC(task: card, managedObjectContext: self.managedObjectContext, onDismiss: {})
        let container = FinderContainerView(customViewController: cardEditVC, navigationBar: nil, finderVC: self)
        cardEditVC.finderContainerView = container
        container.navigationBar = WorkspaceNavBar(workspaceFinderVC: self, containerView: container, workspaceAccessible: self.workspaceAccessible)
        container.backgroundColor = .myBackGroundColor()
        container.layout()
        return container
    }
    
    func newContainerViewForNewCard(under page: Page) -> FinderContainerView {
        let newCardVC = NewCardVC(prechosenPage: page)
        let navItem = UINavigationItem()
        let title = UILabel()
        title.text = "New Card"
        navItem.titleView = title
        let navBar = UINavigationBar()
        navBar.setItems([navItem], animated: true)
        navBar.barTintColor = .myBackGroundColor()
        let container = FinderContainerView(customViewController: newCardVC, navigationBar: navBar, finderVC: self)
        newCardVC.finderContainerView = container
        container.backgroundColor = .myBackGroundColor()
        container.layout()
        return container
    }
}
