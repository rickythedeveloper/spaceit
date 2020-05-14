//
//  WorkspaceFinderVC+DataSource.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import RickyFramework

extension WorkspaceFinderVC: FinderVCDataSource {
//    TODO
    func widthConstraint(for containerView: FinderContainerView) -> NSLayoutConstraint {
        return containerView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, multiplier: 0.5)
    }
    
    func numberOfSections(in finderStyleTableView: FinderTableView) -> Int {
        return 2
    }
    
    func finderTableView(_ tableView: FinderTableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Pages"
        default:
            return "Cards"
        }
    }
    
    func finderTableView(_ tableView: FinderTableView, numberOfRowsInSection section: Int) -> Int {
        guard let page = tableView.information as? Page else {return 1}

        switch section {
        case 0:
            return page.numberOfChildren() + 1
        default:
            return page.numberOfCards() + 1
        }
    }
    
    func finderTableView(_ tableView: FinderTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let page = tableView.information as? Page else {return UITableViewCell()}
        
        var cell: UITableViewCell
        if indexPath.section == 0 {
            if indexPath.row < page.numberOfChildren() {
                cell = tableView.dequeueReusableCell(withIdentifier: childPageCellID, for: indexPath)
                cell.textLabel?.text = page.childrenArray().sortedByName()[indexPath.row].name
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: newPageCellID, for: indexPath)
//                TODO (new page cell)
                cell.textLabel?.text = "new page cell here"
            }
        } else {
            if indexPath.row < page.numberOfCards() {
                cell = tableView.dequeueReusableCell(withIdentifier: childCardCellID, for: indexPath)
                cell.textLabel?.text = page.cardsArray().sortedByCreationDate(oldFirst: true)[indexPath.row].question
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: newCardCellID, for: indexPath)
//                TODO (new card cell)
                cell.textLabel?.text = "new card cell here"
            }
        }
        return cell
    }
}
