//
//  WorkspaceColumnVC+TableViewDelegateDataSource.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 31/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import FinderViewController

extension WorkspaceColumnVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Pages"
        default:
            return "Cards"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableView = tableView as? ColumnTableView else {fatalError()}
        guard let page = tableView.information as? Page else {fatalError()}
        
        switch section {
        case 0:
            return page.numberOfChildren() + 1
        default:
            if self.workspaceAccessible == nil {
                return page.numberOfCards() + 1
            } else {
                return page.numberOfCards() // if accessed by WorkspaceAccessible, don't show new card cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableView = tableView as? ColumnTableView else {fatalError()}
        guard let page = tableView.information as? Page else {fatalError()}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIDFor(indexPath: indexPath), for: indexPath)
        cell.cleanCell()
        cell.textLabel?.numberOfLines = 0
        
        switch cellTypeFor(indexPath: indexPath) {
        case .childPage:
            cell.textLabel?.text = page.childrenArray().sortedByName()[indexPath.row].name
            break
        case .addPage:
            let textField = WorkspaceNewPageTF(columnTableView: tableView)
            cell.contentView.addSubview(textField)
            let padding: CGFloat = 5.0
            NSLayoutConstraint.activate(textField.constraintsToFit(within: cell.contentView.safeAreaLayoutGuide, insets: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)))
            break
        case .childCard:
            cell.textLabel?.text = page.cardsArray().sortedByCreationDate(oldFirst: true)[indexPath.row].question
            break
        case .addCard:
            cell.textLabel?.text = "New Card"
            cell.textLabel?.textColor = .systemGray
            cell.textLabel?.textAlignment = .center
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if cellTypeFor(indexPath: indexPath) == .addPage {return nil} // cannot select add card cell
        if workspaceAccessible != nil && cellTypeFor(indexPath: indexPath) == .childCard {return nil} // if accessed by WorkspaceAccessible, don't let them select child card
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tableView = tableView as? ColumnTableView else {fatalError()}
        guard let page = tableView.information as? Page else {fatalError()}
        self.workspaceViewController.highlightedColumnIndex = tableView.columnIndex // this will trigger finderViewController(_ finderViewController: FinderViewController, didMoveSelectionHorizontallyTo highlightedColumnIndex: Int)
        
        switch cellTypeFor(indexPath: indexPath) {
        case .childPage:
            let childPage = self.shownChildPages(of: page)[indexPath.row]
            let childColumn = self.workspaceViewController.columnFor(page: childPage)
            self.showNewColumnReplacing(under: self.columnIndex + 1, with: childColumn, completion: {})
            break
        case .addPage:
            break
        case .childCard:
            let childCard = self.shownChildCards(of: page)[indexPath.row]
            let cardColumn = self.workspaceViewController.column(for: childCard)
            self.showNewColumnReplacing(under: self.columnIndex + 1, with: cardColumn, completion: {})
            break
        case .addCard:
            let column = self.workspaceViewController.columnForNewCardVC(under: page)
            self.showNewColumnReplacing(under: self.columnIndex + 1, with: column, completion: {})
            break
        }
    }
    
    private func showNewColumnReplacing(under index: Int, with column: FinderColumn, completion: @escaping () -> Void) {
        self.workspaceViewController.hideColumn(at: index + 1, on: .trailingSide, completion: {
            self.workspaceViewController.replaceColumns(under: index, with: column, completion: {
                self.workspaceViewController.showColumn(column, on: .trailingSide, completion: {})
            })
        })
    }
    
    private enum CellType {
        case childPage
        case addPage
        case childCard
        case addCard
    }
    
    private func cellTypeFor(indexPath: IndexPath) -> CellType {
        guard let page = tableView.information as? Page else {return .childPage}
        if indexPath.section == 0 { // child page section
            if indexPath.row < page.numberOfChildren() {
                return .childPage
            } else {
                return .addPage
            }
        } else { // card section
            if indexPath.row < page.numberOfCards() {
                return .childCard
            } else {
                return .addCard
            }
        }
    }
    
    private func cellIDFor(indexPath: IndexPath) -> String {
        switch cellTypeFor(indexPath: indexPath) {
        case .childPage:
            return childPageCellID
        case .addPage:
            return addPageCellID
        case .childCard:
            return childCardCellID
        case .addCard:
            return addCardCellID
        }
    }
    
    private func shownChildPages(of page: Page) -> [Page] {
        return page.childrenArray().sortedByName()
    }
    
    private func shownChildCards(of page: Page) -> [TaskSaved] {
        return page.cardsArray().sortedByCreationDate(oldFirst: true)
    }
}
