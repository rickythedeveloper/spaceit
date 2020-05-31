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
            return page.numberOfCards() + 1
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
            cell.textLabel?.text = "add card"
            cell.textLabel?.textColor = .red
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if cellTypeFor(indexPath: indexPath) == .addPage {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tableView = tableView as? ColumnTableView else {fatalError()}
        guard let page = tableView.information as? Page else {fatalError()}
        
        switch cellTypeFor(indexPath: indexPath) {
        case .childPage:
            self.workspaceViewController.removeColumn(under: self.columnIndex + 1, animationDuration: 0, completion: {
                let childPage = self.shownChildPages(of: page)[indexPath.row]
                let childColumn = self.workspaceViewController.columnFor(page: childPage)
                self.workspaceViewController.appendColumn(finderColumn: childColumn, animationInterval: 0, completion: {
                    self.workspaceViewController.showColumn(childColumn, on: .trailingSide, completion: {})
                })
            })
            break
        case .addPage:
            break
        case .childCard:
            self.workspaceViewController.removeColumn(under: self.columnIndex + 1, animationDuration: 0, completion: {
                let childCard = self.shownChildCards(of: page)[indexPath.row]
                let cardColumn = self.workspaceViewController.column(for: childCard)
                self.workspaceViewController.appendColumn(finderColumn: cardColumn, animationInterval: 0, completion: {
                    self.workspaceViewController.showColumn(cardColumn, on: .trailingSide, completion: {})
                })
            })
            break
        case .addCard:
            self.workspaceViewController.removeColumn(under: self.columnIndex + 1, animationDuration: 0, completion: {
                let column = self.workspaceViewController.columnForNewCardVC(under: page)
                self.workspaceViewController.appendColumn(finderColumn: column, animationInterval: 0, completion: {
                    self.workspaceViewController.showColumn(column, on: .trailingSide, completion: {})
                })
            })
            break
        }
    }
    
    private enum CellType {
        case childPage
        case addPage
        case childCard
        case addCard
    }
    
    private func cellTypeFor(indexPath: IndexPath) -> CellType {
        if indexPath.section == 0 { // child page section
            if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 { // last row
                return .addPage
            } else { // rest
                return .childPage
            }
        } else { // card section
            if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 { // last row
                return .addCard
            } else { // rest
                return .childCard
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
