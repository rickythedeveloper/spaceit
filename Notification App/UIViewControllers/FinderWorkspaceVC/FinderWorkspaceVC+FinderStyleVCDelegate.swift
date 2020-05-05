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
        return workspaceContainerView(for: topPage)
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
    
    func finderStyleTableView(_ tableView: FinderStyleTableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let page = tableView.information as? Page, let cellType = cellType(for: indexPath, page: page) else {return indexPath}
        if cellType == .newPage {
            return nil
        }
        return indexPath
    }
    
    func finderStyleTableView(_ tableView: FinderStyleTableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let page = tableView.information as? Page, let cellType = cellType(for: indexPath, page: page) else {return true}
        if cellType == .newPage {
            return false
        }
        return true
    }
    
    func finderStyleNextView(for containerView: FinderStyleContainerView, didSelectRowAt indexPath: IndexPath) -> FinderStyleContainerView? {
        guard let tableView = containerView.tableView, let currentPage = tableView.information as? Page else {return nil}
        guard let cellType = cellType(for: indexPath, page: currentPage) else {return nil}
        
        switch cellType {
        case .childPage:
            let shownPage = currentPage.childrenArray().sortedByName()[indexPath.row]
            return workspaceContainerView(for: shownPage)
        case .newPage:
            tableView.deselectRow(at: indexPath, animated: false)
            return nil
        case .childCard:
            let shownCard = currentPage.cardsArray().sortedByCreationDate(oldFirst: true)[indexPath.row]
            return cardEditContainer(task: shownCard)
        case .newCard:
            return nil
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
        self.view.endEditing(true)
        guard let newPageTF = textField as? NewPageTextField, let containerView = newPageTF.containerView, let tableView = containerView.tableView, let page = tableView.information as? Page else {return true}
        guard let text = textField.text, text.hasContent() else {return true}
        addChildPage(for: page, name: text, completion: {
            self.standardReloadProcedure()
            textField.text = nil
        })
        return true
    }
}
