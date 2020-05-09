//
//  FinderWorkspaceVC+Navigation.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 04/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import RickyFramework

// MARK: Navigation
extension FinderWorkspaceVC {
    
    func workspaceContainerView(for page: Page?) -> FinderStyleContainerView {
        let tableView = newFinderStyleTableView(information: page)
        let containerView = FinderStyleContainerView(finderStyleTableView: tableView, navigationBar: nil, finderStyleVC: self)
        containerView.navigationBar = FinderWorkspaceNavBar(finderWorkspaceVC: self, containerView: containerView, workspaceAccessible: workspaceAccessible)
        containerView.layout()
        return containerView
    }
    
    func cardEditContainer(task: TaskSaved) -> FinderStyleContainerView {
        let cardEditVC = CardEditVC(task: task, managedObjectContext: managedObjectContext, onDismiss: {
            self.reloadViews(reloadsTableViews: true, completion: {})
        })
        let containerView = FinderStyleContainerView(customViewController: cardEditVC, navigationBar: nil, finderStyleVC: self)
        cardEditVC.finderStyleContainerView = containerView
        containerView.navigationBar = FinderWorkspaceNavBar(finderWorkspaceVC: self, containerView: containerView, workspaceAccessible: workspaceAccessible)
        containerView.layout()
        return containerView
    }
}
