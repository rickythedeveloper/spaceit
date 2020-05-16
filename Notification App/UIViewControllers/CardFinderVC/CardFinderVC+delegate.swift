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
        let task = allTasks[indexPath.row]
        let cardEditVC = CardEditVC(task: task, managedObjectContext: managedObjectContext, onDismiss: {})
        let container = cardEditVC.newContainerView(finderVC: self)
        removeContainerViews(under: tableView.containerIndex() + 1)
        addContainerView(container)
    }
    
    func finderTableView(_ tableView: FinderTableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row == 0 ? false : true
    }
}
