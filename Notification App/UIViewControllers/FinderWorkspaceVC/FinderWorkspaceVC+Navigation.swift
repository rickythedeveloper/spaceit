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
    func navigationBar(for containerView: FinderStyleContainerView) -> UINavigationBar? {
        if let tableView = containerView.tableView {
            let navBar = UINavigationBar()
            let navItem = UINavigationItem()
            let pageName = UILabel()
            pageName.text = (tableView.information as? Page)?.name
            navItem.titleView = pageName
            if tableView.information as? Page != topPage {
                let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: containerView, action: #selector(containerView.dismiss))
                navItem.leftBarButtonItem = backButton
            }
            navBar.setItems([navItem], animated: true)
            return navBar
        } else if let cardEditVC = containerView.customViewController as? CardEditVC {
            let navBar = UINavigationBar()
            let navItem = UINavigationItem()
            let title = UILabel()
            title.text = "Edit Card"
            navItem.titleView = title
            navItem.rightBarButtonItems = [cardEditVC.deleteButtonItem(), cardEditVC.archiveButtonItem(), cardEditVC.discardChangesButtonItem()]
            navBar.setItems([navItem], animated: true)
            return navBar
        }
        return nil
    }
    
    func workspaceContainerView(for page: Page?) -> FinderStyleContainerView {
        let tableView = newFinderStyleTableView(information: page)
        let containerView = FinderStyleContainerView(finderStyleTableView: tableView, navigationBar: nil, finderStyleVC: self)
        containerView.navigationBar = navigationBar(for: containerView)
        containerView.layout()
        return containerView
    }
    
    func cardEditContainer(task: TaskSaved) -> FinderStyleContainerView {
        let cardEditVC = CardEditVC(task: task, managedObjectContext: managedObjectContext, onDismiss: {
            self.reloadViews(reloadsTableViews: true)
        })
        let containerView = FinderStyleContainerView(customViewController: cardEditVC, navigationBar: nil, finderStyleVC: self)
        cardEditVC.finderStyleContainerView = containerView
        containerView.navigationBar = navigationBar(for: containerView)
        containerView.layout()
        return containerView
    }
}
