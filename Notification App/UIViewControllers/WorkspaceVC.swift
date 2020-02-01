//
//  WorkspaceVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 31/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import CoreData

class WorkspaceVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    private var page: Page?
    private var managedObjectContext: NSManagedObjectContext!
    
    private var tableV: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    private var cellID = "workspaceTableVCell"
    
    private var newPageTF: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
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
        
        newPageTF.delegate = self
        
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
        
        self.title = self.page?.name
        
        self.view.addSubview(tableV)
        tableV.constrainToTopSafeAreaOf(view, padding: padding)
        tableV.constrainToSideSafeAreasOf(view, padding: padding)
        tableV.constrainToBottomSafeAreaOf(view, padding: padding)
        tableV.backgroundColor = .red
        
        newPageTF.backgroundColor = UIColor.tvBackground()
        newPageTF.font = UIFont.preferredFont(forTextStyle: .title2)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 1))
        newPageTF.leftView = paddingView
        newPageTF.leftViewMode = .always
        newPageTF.layer.cornerRadius = padding
        newPageTF.layer.masksToBounds = true
        newPageTF.textAlignment = .center
        newPageTF.placeholder = "New page"
    }
}

// MARK: Text field delegate & data source
extension WorkspaceVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        guard let text = textField.text else {return true}
        if text.hasContent() {
            // MARK: add a new page here
        }
        return true
    }
}

// MARK: Table view delegate & data source
extension WorkspaceVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let n = self.page?.numberOfChildren() {
                return n + 1
            } else {
                return 1
            }
        } else {
            return self.page?.numberOfCards() ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == self.page?.numberOfChildren() {
            let padding: CGFloat = 10.0
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            cell.contentView.addSubview(newPageTF)
            newPageTF.constrainToTopSafeAreaOf(cell.contentView, padding: padding)
            newPageTF.constrainToSideSafeAreasOf(cell.contentView, padding: padding)
            newPageTF.constrainToBottomSafeAreaOf(cell.contentView, padding: padding)
            return cell
        } else if indexPath.section == 0 {
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
