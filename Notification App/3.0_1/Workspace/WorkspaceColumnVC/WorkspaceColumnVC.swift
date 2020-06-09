//
//  WorkspaceColumnVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 31/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import FinderViewController
import CoreData

class WorkspaceColumnVC: UIViewController, WorkspaceAccessible {
    let managedObjectContext = NSManagedObjectContext.defaultContext()
    let childPageCellID = "childPageCellID"
    let addPageCellID = "addPageCellID"
    let childCardCellID = "childCardCellID"
    let addCardCellID = "addCardCellID"
    
    unowned var workspaceViewController: WorkspaceViewController!
    unowned var workspaceColumn: FinderColumn!
    var tableView = ColumnTableView()
    
    var columnIndex: Int {get {self.workspaceViewController.finderColumns.firstIndex(of: self.workspaceColumn)!}}
    var manageObjectContext: NSManagedObjectContext {get {self.workspaceViewController.managedObjectContext}}
    
    // Workspace Accessible
    var workspaceAccessible: WorkspaceAccessible? // this will be non-nil when this vc is used as a page selector
    var chosenPage: Page? { // this will be used by the original workspace column vc
        willSet {
            if let page = newValue {
                moveThisPageUnder(page)
            }
        }
    }
    
    init(workspaceAccessible: WorkspaceAccessible? = nil) {
        super.init(nibName: nil, bundle: nil)
        initialSetup()
        self.workspaceAccessible = workspaceAccessible
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func setTitle(_ name: String?) {
        navigationItem.title = name
    }
}

