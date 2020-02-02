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
    
    private var onDismiss: () -> Void
    
    init(page: Page? = nil, onDismiss: @escaping () -> Void = {}) {
        self.page = page
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        onDismiss()
    }
}

// MARK: Actions
extension WorkspaceVC {
    private func addChildPage() {
        guard let text = newPageTF.text else {return}
        guard let thisPage = self.page else {return}
        
        let newPage = Page.createPageInContext(name: text, context: self.managedObjectContext)
        thisPage.addToChildren(newPage)
        self.managedObjectContext.saveContext()
        self.managedObjectContext.saveContext(completion: {
            self.reloadTableView()
        })
        self.newPageTF.text = ""
    }
    
    private func reloadTableView() {
        self.tableV.reloadSections(IndexSet(integersIn: 0...1), with: .automatic)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let textFieldMaxY = (newPageTF.convert(newPageTF.frame, to: self.view)).maxY
            self.tableV.setContentOffset(CGPoint(x: 0, y: max(0, textFieldMaxY - keyboardSize.minY)), animated: true)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        self.tableV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @objc private func optionPressed() {
        var actions = [(String, UIAlertAction.Style, ()->Void)]()
        
        actions.append(("Edit name", UIAlertAction.Style.default, {
//            MARK: edit name
        }))
        
        if self.page?.isTopPage() == true {
            actions.append(("Add higher level page", UIAlertAction.Style.default, {
//                MARK: add higher level page
            }))
        }
        
        if self.page?.isTopPage() == false || self.page?.numberOfChildren() == 1 {
            actions.append(("Delete page", UIAlertAction.Style.destructive, {
//                MARK: delete page
            }))
        }
        
        let ac = UIAlertController.workspaceActionSheet(title: self.page?.name ?? "Page actions", actions: actions)
        if let popoverController = ac.popoverPresentationController {
            popoverController.barButtonItem = self.navigationItem.rightBarButtonItem
        }
        self.present(ac, animated: true, completion: nil)
    }
}

extension WorkspaceVC {
//    MARK: Data set up
    private func setup() {
        self.managedObjectContext = self.defaultManagedObjectContext()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
        self.view.backgroundColor = UIColor.myBackGroundColor()
        
        let optionNavBarItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(optionPressed))
        self.navigationItem.rightBarButtonItem = optionNavBarItem
        
        self.view.addSubview(tableV)
        tableV.constrainToTopSafeAreaOf(view, padding: padding)
        tableV.constrainToSideSafeAreasOf(view, padding: padding)
        tableV.constrainToBottomSafeAreaOf(view, padding: padding)
        
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
        
        guard let text = textField.text, text.hasContent() else {return true}
        addChildPage()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == self.page?.childrenArray().count {
            tableView.deselectRow(at: indexPath, animated: true)
            newPageTF.becomeFirstResponder()
        } else if indexPath.section == 0 {
            let newPageVC = WorkspaceVC(page: self.page?.childrenArray()[indexPath.row], onDismiss: {
                tableView.deselectRow(at: indexPath, animated: true)
            })
            self.navigationController?.pushViewController(newPageVC, animated: true)
        } else {
            guard let thisPage = self.page else {return}
            let cardEditVC = CardEditVC(task: thisPage.cardsArray()[indexPath.row], managedObjectContext: self.managedObjectContext) {
                tableView.deselectRow(at: indexPath, animated: true)
            }
            self.navigationController?.pushViewController(cardEditVC, animated: true)
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
