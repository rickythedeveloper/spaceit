//
//  WorkspaceColumnVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 31/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import FinderViewController
import CoreData

class WorkspaceColumnVC: UIViewController {
    let managedObjectContext = NSManagedObjectContext.defaultContext()
    let childPageCellID = "childPageCellID"
    let addPageCellID = "addPageCellID"
    let childCardCellID = "childCardCellID"
    let addCardCellID = "addCardCellID"
    
    unowned var workspaceViewController: WorkspaceViewController!
    unowned var workspaceColumn: FinderColumn!
    var tableView = ColumnTableView()
    
    var columnIndex: Int {get {self.workspaceViewController.finderColumns.firstIndex(of: self.workspaceColumn)!}}
    
    init() {
        super.init(nibName: nil, bundle: nil)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
    }
}

extension WorkspaceColumnVC {
    private func initialSetup() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        for cellid in [childPageCellID, addPageCellID, childCardCellID, addCardCellID] {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellid)
        }
        tableView.dataSource = self
        tableView.delegate = self
        for cardSort in CardSortingSyetem.allCases {
            tableView.register(cardSort.cellClass(), forCellReuseIdentifier: cardSort.rawValue)
        }
        view = tableView
    }
}

