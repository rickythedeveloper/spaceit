//
//  WorkspaceViewController+Keyboard.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 20/06/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import FinderViewController

extension WorkspaceViewController {
    override var keyCommands: [UIKeyCommand]? {
        guard UserSettings.isProUser else { return []}
        
        return [
            UIKeyCommand(title: "Select item below", image: nil, action: #selector(self.upKeyPressed), input: UIKeyCommand.inputUpArrow, modifierFlags: [], propertyList: nil, alternates: [], discoverabilityTitle: "Select item below", attributes: [], state: .on),
            UIKeyCommand(title: "Select item above", image: nil, action: #selector(self.downKeyPressed), input: UIKeyCommand.inputDownArrow, modifierFlags: [], propertyList: nil, alternates: [], discoverabilityTitle: "Select item above", attributes: [], state: .on),
            UIKeyCommand(title: "Select previous column", image: nil, action: #selector(self.leftKeyPressed), input: UIKeyCommand.inputLeftArrow, modifierFlags: [], propertyList: nil, alternates: [], discoverabilityTitle: "Select previous column", attributes: [], state: .on),
            UIKeyCommand(title: "Select next column", image: nil, action: #selector(self.rightKeyPressed), input: UIKeyCommand.inputRightArrow, modifierFlags: [], propertyList: nil, alternates: [], discoverabilityTitle: "Select next column", attributes: [], state: .on),
            UIKeyCommand(title: "Create a new card", image: nil, action: #selector(self.openNewCardView), input: "n", modifierFlags: [.command], propertyList: nil, alternates: [], discoverabilityTitle: "Create a new card", attributes: [], state: .on),
        ]
    }
    
    @objc private func upKeyPressed() {
        self.selectCellAboveOfHighlightedTable()
        cellSelectionChanged()
    }
    
    @objc private func downKeyPressed() {
        self.selectCellBelowOfHighlightedTable()
        cellSelectionChanged()
    }
    
    @objc private func leftKeyPressed() {
        self.moveToPreviousColumn()
        cellSelectionChanged()
    }
    
    @objc private func rightKeyPressed() {
        self.moveToNextColumn()
        self.selectCellBelowOfHighlightedTable()
        cellSelectionChanged()
    }
    
    private func cellSelectionChanged() {
        if let tableView = self.highlightedColumnTableView { // if the newly highlighted column has a designated table view
            guard let page = tableView.information as? Page else {return}
            guard let navVC = self.highlightedFinderColumn?.viewController as? UINavigationController, navVC.viewControllers.count > 0, let workspaceColumnVC = navVC.viewControllers[0] as? WorkspaceColumnVC else {return}
            guard let highlightedTableView = self.highlightedColumnTableView, let highlightedIndexPath = highlightedTableView.indexPathForSelectedRow else {return}
            
            // Generate the next column. Hide excess columns. Replace unnecessary columns with the new column. Show the new column.
            if let nextColumn = workspaceColumnVC.nextColumnOnDidSelectRow(at: highlightedIndexPath, inside: page) {
                self.hideColumn(at: tableView.columnIndex + 2, on: .trailingSide, completion: {
                    self.replaceColumns(under: tableView.columnIndex + 1, with: nextColumn, completion: {
                        if self.tableWidth == 1 {
                            self.showColumn(at: tableView.columnIndex, on: .trailingSide, completion: {})
                        } else {
                            self.showColumn(nextColumn, on: .trailingSide, completion: {})
                        }
                    })
                })
            } else {
                // if no next column is found, just show the currently highlighted table view
                self.showColumn(at: tableView.columnIndex, on: .trailingSide, completion: {})
            }
        } else { // if the newly highlighted column does not have a designated table view
            guard let highlightedColumnIndex = self.highlightedColumnIndex else {return}
            self.showColumn(at: highlightedColumnIndex, on: .trailingSide, completion: {})
        }
    }
    
    @objc private func openNewCardView() {
        guard let tableView = self.highlightedColumnTableView, let lastIndexPath = tableView.lastIndexPath() else {return}
        tableView.selectRow(at: lastIndexPath, animated: false, scrollPosition: .none)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: lastIndexPath)
        self.rightKeyPressed()
    }
}
