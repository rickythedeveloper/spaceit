//
//  WorkspaceViewController+Factory.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 31/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import FinderViewController

extension WorkspaceViewController {
    func columnFor(page: Page) -> FinderColumn {
        let vc = WorkspaceColumnVC()
        vc.tableView.information = page
        let navC = UINavigationController(rootViewController: vc)
        let column = FinderColumn(finderViewController: self, viewController: navC, finderTableView: vc.tableView)
        vc.workspaceViewController = self
        vc.workspaceColumn = column
        vc.title = page.name
        return column
    }
    
    func column(for task: TaskSaved) -> FinderColumn {
        let vc = CardEditVC(task: task, managedObjectContext: managedObjectContext, onDismiss: {})
        let navC = UINavigationController(rootViewController: vc)
        let column = FinderColumn(finderViewController: self, viewController: navC)
        vc.finderColumn = column
        return column
    }
    
    func columnForNewCardVC(under page: Page?) -> FinderColumn {
        let vc = NewCardVC(prechosenPage: page)
        let newCardVC = UINavigationController(rootViewController: vc)
        let column = FinderColumn(finderViewController: self, viewController: newCardVC)
        vc.finderColumn = column
        return column
    }
}
