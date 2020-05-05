//
//  FinderWorkspaceVC+FinderStyleVCDelegate.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 04/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import RickyFramework

extension FinderWorkspaceVC: FinderStyleVCDelegate {
    func finderStyleFirstContainer() -> FinderStyleContainerView {
        let tableView = newFinderStyleTableView(information: topPage)
        let containerView = FinderStyleContainerView(finderStyleTableView: tableView, navigationBar: nil, finderStyleVC: self)
        containerView.navigationBar = navigationBar(for: containerView)
        containerView.layout()
        return containerView
    }
    
    func finderStyleNextView(for containerView: FinderStyleContainerView, didSelectRowAt indexPath: IndexPath) -> FinderStyleContainerView? {
        guard let tableView = containerView.tableView, let currentPage = tableView.information as? Page else {return nil}
        if indexPath.section == pageSection { // if page section is selected
            if indexPath.row == tableView.numberOfRows(inSection: pageSection) { // if new page cell is selected
                return nil
            } else { // existing page
                let tableView = newFinderStyleTableView(information: currentPage.childrenArray().sortedByName()[indexPath.row])
                return self.workspaceContainerView(for: tableView)
            }
        } else if indexPath.section == cardSection { // if card section is selected
            if indexPath.row == tableView.numberOfRows(inSection: cardSection) { // if new card is selected
                
            } else { // existing card
                let card = currentPage.cardsArray().sortedByCreationDate(oldFirst: true)[indexPath.row]
                return cardEditContainer(task: card)
            }
            return nil
        }
        return nil
    }
    
    func numberOfSections(in finderStyleTableView: FinderStyleTableView) -> Int {
        return 2
    }
    
    func finderStyleTableView(_ tableView: FinderStyleTableView, titleForHeaderInSection section: Int) -> String? {
        if section == pageSection {
            return "Page"
        } else if section == cardSection {
            return "Cards"
        }
        return nil
    }
    
    func finderStyleTableView(_ tableView: FinderStyleTableView, numberOfRowsInSection section: Int) -> Int {
        guard let info = tableView.information as? Page else {return 0}
        if section == pageSection {
            return info.numberOfChildren() + 1
        } else if section == cardSection {
            return info.numberOfCards()
        } else {
            return 0
        }
    }
    
    func finderStyleTableView(_ tableView: FinderStyleTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        guard let info = tableView.information as? Page else {return defaultCell}
        guard let cellType = cellType(for: indexPath, page: info) else {return defaultCell}
        guard let containerView = self.containerViewFor(tableView) else {return defaultCell}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableView.cellID, for: indexPath)
        cell.cleanCell()

        switch cellType {
        case .childPage:
            let shownPage = info.childrenArray().sortedByName()[indexPath.row]
            cell.textLabel?.text = shownPage.name
            return cell
        case .newPage:
            return NewPageTableViewCell(reuseIdentifier: tableView.cellID, TFdelegate: self, containerView: containerView)
        case .childCard:
            let shownCard = info.cardsArray().sortedByCreationDate(oldFirst: true)[indexPath.row]
            cell.textLabel?.text = shownCard.question
            return cell
        case .newCard:
            return defaultCell
        }
    }
    
    func widthFor(_ containerView: FinderStyleContainerView) -> CGFloat {
        if UIDevice.current.model == "iPad" {
            if let _ = containerView.tableView {
                return 500.0
            } else if let _ = containerView.customView {
                return 700.0
            }
        }
        return -1
    }

    func widthDimensionFor(_ containerView: FinderStyleContainerView) -> NSLayoutDimension? {
        if UIDevice.current.model == "iPhone" {
            return self.view.widthAnchor
        }
        return nil
    }
}

extension FinderWorkspaceVC {
    private func cellType(for indexPath: IndexPath, page: Page) -> WorkspaceCellType? {
        if indexPath.section == pageSection {
            if indexPath.row == page.numberOfChildren() {
                return .newPage
            } else if indexPath.row < page.numberOfChildren() {
                return .childPage
            }
        } else if indexPath.section == cardSection {
            if indexPath.row == page.numberOfCards() {
                return .newCard
            } else if indexPath.row < page.numberOfCards() {
                return .childCard
            }
        }
        return nil
    }
}

private enum WorkspaceCellType {
    case childPage
    case newPage
    case childCard
    case newCard
}

extension FinderWorkspaceVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("should return")
        return true
    }
}
