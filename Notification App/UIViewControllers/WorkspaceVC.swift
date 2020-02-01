//
//  WorkspaceVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 31/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import CoreData

class WorkspaceVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var page: Page?
    private var managedObjectContext: NSManagedObjectContext!
    
    private var tableV: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    private var cellID = "workspaceTableVCell"
    
    init(page: Page? = nil) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewSetup()
        
//        let label = UILabel()
//        label.text = self.page?.breadCrumb()
//        label.frame = CGRect(x: 100, y: 100, width: 200, height: 100)
//        view.addSubview(label)
    }
}

extension WorkspaceVC {
//    MARK: Data set up
    private func setup() {
        self.managedObjectContext = self.defaultManagedObjectContext()
        
        tableV.delegate = self
        tableV.dataSource = self
        tableV.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        guard page == nil else {return}
        let pages = self.pagesFetched()
        if pages.count == 0 {
            noPageSetup()
        } else {
            self.page = pages[0].topPage()
        }
    }
    
//    MARK: No page set up
    private func noPageSetup() {
        self.page = Page.createPageInContext(name: "My Workspace", id: UUID(), context: self.managedObjectContext)
        self.managedObjectContext.saveContext()
    }
    
//    MARK: View set up
    private func viewSetup() {
        let padding: CGFloat = 10.0
        self.view.addSubview(tableV)
        tableV.constrainToTopSafeAreaOf(view, padding: padding)
        tableV.constrainToSideSafeAreasOf(view, padding: padding)
        tableV.constrainToBottomSafeAreaOf(view, padding: padding)
        tableV.backgroundColor = .red
    }
}

extension WorkspaceVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.page?.numberOfChildren() ?? 0
        } else {
            return self.page?.numberOfCards() ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            cell.textLabel?.text = self.page?.childrenArray()[indexPath.row].name
            cell.backgroundColor = .clear
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            cell.textLabel?.text = self.page?.cardsArray()[indexPath.row].question
            cell.backgroundColor = .clear
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Pages"
        } else {
            return "Cards"
        }
    }
}
