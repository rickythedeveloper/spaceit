//
//  WorkspaceVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 31/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import CoreData

/*
class WorkspaceVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, WorkspaceAccessible {
    var chosenPage: Page? {
        willSet(newPage) {
            if newPage != nil {
                moveThisPageUnder(newPage!)
            }
        }
    }
    
    private var page: Page?
    private var managedObjectContext: NSManagedObjectContext!
    
    private var tableV: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    private var textCellID = "workspaceTextCell"
    private let newtfCellID = "workspaceNewTFCell"
    private let addCardCellID = "workspaceAddCardCell"
    
    private var newPageTF: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private var newCardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(textStyle: .title1), forImageIn: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private var onDismiss: () -> Void
    private var thisPageDeleted = false
    private var workspaceAccessible: WorkspaceAccessible?
    
    private var noWorkspaceAlert: UIAlertController?
    private var coredataUpdateTimer: Timer?
    
    init(page: Page? = nil, onDismiss: @escaping () -> Void = {}, workspaceAccessible: WorkspaceAccessible? = nil) {
        self.page = page
        self.onDismiss = onDismiss
        self.workspaceAccessible = workspaceAccessible
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navBarTouched)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        standardReloadProcedure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        onDismiss()
    }
}

// MARK: Actions
extension WorkspaceVC {
    /// Add new page under this page if there is a text in the new page text field.
    private func addChildPage() {
        guard let text = newPageTF.text else {return}
        guard let thisPage = self.page else {return}
        
        let newPage = Page.createPageInContext(name: text, context: self.managedObjectContext)
        thisPage.addToChildren(newPage)
        self.managedObjectContext.saveContext()
        self.managedObjectContext.saveContext(completion: {
            self.standardReloadProcedure()
        })
        self.newPageTF.text = ""
    }
    
    /// Offset the content if needed based on  the keyboard frame.
    @objc private func keyboardWillShow(notification: NSNotification) {
        if self.newPageTF.isFirstResponder {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let textFieldMaxY = (newPageTF.convert(newPageTF.frame, to: nil)).maxY
                self.tableV.setContentOffset(CGPoint(x: 0, y: self.tableV.contentOffset.y + max(0, textFieldMaxY - keyboardSize.minY)), animated: true)
            }
        }
    }
    
    /// shows all the possible actions related to this page on an alert.
    @objc private func optionPressed() {
        var actions = [(String, UIAlertAction.Style, ()->Void)]()
        
        actions.append(("Edit name", UIAlertAction.Style.default, {
            self.editPageName()
        }))
        
//        if self.page?.isTopPage() == true {
//            actions.append(("Add higher level page", UIAlertAction.Style.default, {
//                self.addHigherPage()
//            }))
//        }
        
//        if self.page?.isTopPage() == false || self.page?.numberOfChildren() == 1 {
//            actions.append(("Delete page", UIAlertAction.Style.destructive, {
//                self.deleteThisPage()
//            }))
//        }

        if self.page?.isTopPage() == false {
            actions.append(("Move page", .default, {
                self.choosePageToMoveTo()
            }))
        }
        
        if self.page?.isTopPage() == false {
            actions.append(("Delete page", UIAlertAction.Style.destructive, {
                self.deleteThisPage()
            }))
        }
        
        let ac = UIAlertController.workspaceActionSheet(title: self.page?.name ?? "Page actions", actions: actions)
        if let popoverController = ac.popoverPresentationController {
            popoverController.barButtonItem = self.navigationItem.rightBarButtonItem
        }
        self.present(ac, animated: true, completion: nil)
    }
    
    @objc private func selectThisPage() {
        if let thisPage = self.page {
            self.workspaceAccessible?.chosenPage = thisPage
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    /// If this page is not the top page, delete this page and save the core data context.
    private func deleteThisPage() {
        guard let thisPage = self.page else {return}
        guard !thisPage.isTopPage() else {return}
        
        self.page = nil
        self.thisPageDeleted = true
        self.managedObjectContext.delete(thisPage)
        self.managedObjectContext.saveContext(completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
//    private func addHigherPage() {
//        guard self.page?.isTopPage() == true else {return}
//        guard let thisPage = self.page else {return}
//
//        let higherPage = Page.createPageInContext(name: "My workspace", context: self.managedObjectContext)
//        thisPage.parent = higherPage
//        self.managedObjectContext.saveContext()
//
//        self.transition(from: self, to: WorkspaceVC(), duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
//    }
    
    /// Shows an alert with a textfield so that the user can edit the page name.
    private func editPageName() {
        guard let thisPage = self.page else {return}
        
        let ac = UIAlertController.editPageNameAlert(textFieldDelegate: self, pageName: thisPage.name, doneAction: { (newName) in
            thisPage.name = newName
            self.managedObjectContext.saveContext()
            self.title = thisPage.name
        }, cancelAction: {
            self.title = thisPage.name
        })
        
        print("before")
        self.present(ac, animated: true, completion: nil)
        print("after")
    }
    
    /// Reloads the tsble view if this page already exists. Otherwise, sets the page to the top page found in the core data.
    @objc private func coreDataObjectsDidChange() {
        coredataUpdateTimer?.invalidate()
        DispatchQueue.main.async {
            self.coredataUpdateTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { (timer) in
                self.updateViewsOnCoredataChange()
            })
        }
    }
    
    private func updateViewsOnCoredataChange() {
        guard self.thisPageDeleted == false else {return}
        standardReloadProcedure()
    }
    
    /// Calls edit page name.
    @objc private func navBarTouched() {
        self.editPageName()
    }
}

extension WorkspaceVC {
//    MARK: Data set up
    /// Sets up the data for this view controller.
    private func setup() {
        self.managedObjectContext = NSManagedObjectContext.defaultContext()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataObjectsDidChange), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        
        tableV.delegate = self
        tableV.dataSource = self
        tableV.register(UITableViewCell.self, forCellReuseIdentifier: textCellID)
        tableV.register(UITableViewCell.self, forCellReuseIdentifier: newtfCellID)
        tableV.register(UITableViewCell.self, forCellReuseIdentifier: addCardCellID)
        tableV.backgroundColor = .clear
        
        newPageTF.delegate = self
    }
    
//    MARK: No page set up
    /// Creates a new page called My Workspace and save onto core data.
    private func noPageSetup() {
        self.page = Page.createPageInContext(name: "My Workspace", id: UUID(), context: self.managedObjectContext)
        self.managedObjectContext.saveContext()
        self.standardReloadProcedure()
    }
    
//    MARK: View set up
    /// Sets up the views in this view controller.
    private func viewSetup() {
        let padding: CGFloat = 10.0
        
        self.title = self.page?.name
        self.view.backgroundColor = UIColor.myBackGroundColor()
        
        if self.workspaceAccessible == nil { // not selecting a page
            let optionNavBarItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(optionPressed))
            self.navigationItem.rightBarButtonItem = optionNavBarItem
        } else {
            let selectThisPageNavBarItem = UIBarButtonItem(image: UIImage(systemName: "checkmark.circle"), style: .plain, target: self, action: #selector(selectThisPage))
            self.navigationItem.rightBarButtonItem = selectThisPageNavBarItem
        }
        
        self.view.addSubview(tableV)
        tableV.constrainToTopSafeAreaOf(view)
        tableV.constrainToSideSafeAreasOf(view)
        tableV.constrainToBottomSafeAreaOf(view)
        
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
    /// If the new page textfield is returning and it has a text, then add a new page.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == newPageTF {
            view.endEditing(true)
            
            guard let text = textField.text, text.hasContent() else {return true}
            addChildPage()
        }
        return true
    }
    
    /// Changes the title of this page according to the texrt field.
    @objc func nameEditingChanged(_ textField: UITextField) {
        self.title = textField.text
    }
}

// MARK: Table view delegate & data source
extension WorkspaceVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let thisPage = self.page else {return 0}
        
        if section == 0 {
            return thisPage.numberOfChildren() + 1
        } else {
            if self.workspaceAccessible == nil { // if not seleccting a page, show the 'add card' cell
                return thisPage.numberOfCards() + 1
            } else {
                return thisPage.numberOfCards() // if selecting a page, do not show the 'add card' cell
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let thisPage = self.page else {return UITableViewCell()}
        
        let padding: CGFloat = 5.0
        
        var cell: UITableViewCell
        if indexPath.section == 0 && indexPath.row >= thisPage.numberOfChildren() {
            // new page tf
            cell = tableView.dequeueReusableCell(withIdentifier: newtfCellID, for: indexPath)
        } else if indexPath.section == 1 && indexPath.row >= thisPage.numberOfCards() {
            // add card
            cell = tableView.dequeueReusableCell(withIdentifier: addCardCellID, for: indexPath)
        } else {
            // text
            cell = tableView.dequeueReusableCell(withIdentifier: textCellID, for: indexPath)
        }
        
        cell.backgroundColor = .clear
        
        if indexPath.section == 0 && indexPath.row >= thisPage.numberOfChildren() {
            cell.contentView.addSubview(newPageTF)
            newPageTF.constrainToTopSafeAreaOf(cell.contentView, padding: padding*2)
            newPageTF.constrainToSideSafeAreasOf(cell.contentView, padding: padding*2)
            newPageTF.constrainToBottomSafeAreaOf(cell.contentView, padding: padding*2)
            return cell
        } else if indexPath.section == 0 {
            cell.textLabel?.text = thisPage.childrenArray()[indexPath.row].name
            cell.backgroundColor = .clear
            return cell
        } else if indexPath.section == 1 && indexPath.row >= thisPage.numberOfCards() {
            cell.contentView.addSubview(newCardButton)
            newCardButton.constrainToTopSafeAreaOf(cell.contentView, padding: padding)
            newCardButton.constrainToBottomSafeAreaOf(cell.contentView, padding: padding
            )
            newCardButton.alignToCenterXOf(cell.contentView)
            return cell
        } else {
            cell.textLabel?.text = thisPage.cardsArray()[indexPath.row].question
            cell.backgroundColor = .clear
            return cell
        }
    }
    
    /// if selecting a page, the user should not be able to select the second section (cards section)
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if self.workspaceAccessible != nil && indexPath.section == 1 {
            return nil
        }
        return indexPath
    }
    
    /// if selecting a page, the user should not be able to highlight the second section (cards section)
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if self.workspaceAccessible != nil && indexPath.section == 1 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let thisPage = self.page else {return}
        
        if indexPath.section == 0 && indexPath.row == thisPage.childrenArray().count {
            tableView.deselectRow(at: indexPath, animated: true)
            newPageTF.becomeFirstResponder()
        } else if indexPath.section == 0 {
            let newPageVC = WorkspaceVC(page: thisPage.childrenArray()[indexPath.row], onDismiss: {
                tableView.deselectRow(at: indexPath, animated: true)
            }, workspaceAccessible: self.workspaceAccessible)
            self.navigationController?.pushViewController(newPageVC, animated: true)
        } else if indexPath.section == 1 && indexPath.row >= thisPage.numberOfCards() {
            self.navigationController?.pushViewController(NewCardVC(prechosenPage: thisPage), animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
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

// MARK: Keyboard Shortcuts
extension WorkspaceVC {
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(title: "New Page", action: #selector(newPageTFBecomesFirstResponder), input: "p", modifierFlags: [.command], discoverabilityTitle: "New page"),
            UIKeyCommand(title: "New Card", action: #selector(createNewCard), input: "n", modifierFlags: [.command], discoverabilityTitle: "New Card"),
            UIKeyCommand(title: "Cards", action: #selector(goToCards), input: UIKeyCommand.inputLeftArrow, modifierFlags: [.command, .shift], discoverabilityTitle: "Cards"),
        ]
    }
    
    @objc private func newPageTFBecomesFirstResponder() {
        self.newPageTF.becomeFirstResponder()
    }
    
    @objc private func createNewCard() {
        self.navigationController?.pushViewController(NewCardVC(prechosenPage: self.page), animated: true)
    }
    
    @objc private func goToCards() {
        self.tabBarController?.selectedIndex = 0
    }
}

// MARK: Reloading data and views
extension WorkspaceVC {
    
    private func standardReloadProcedure() {
        let pages = fetchPages()
        if pages.count == 0 {
            showNoPageAlert()
        } else {
            if page == nil {
                findTopPageAndAssignToThisPage(pages: pages)
            }
            reloadViews()
            self.noWorkspaceAlert?.dismiss(animated: true, completion: nil)
        }
    }
    
    /// Fetch all the pages in the core data
    private func fetchPages() -> [Page] {
        return Array.pagesFetched(managedObjectContext: self.managedObjectContext)
    }
    
    /// Show alert asking if the user wants to create a page.
    private func showNoPageAlert() {
        noWorkspaceAlert = UIAlertController.noWorkspaceAlert(createPage: self.noPageSetup)
        self.present(noWorkspaceAlert!, animated: true, completion: nil)
    }
    
    /// GIven an array of pages, this function finds the top page whilst handling clashes and then assifns the top page to this page.
    private func findTopPageAndAssignToThisPage(pages: [Page]) {
        guard pages.count > 0 else {fatalError("The number of pages is 0 where it should not be")}
        if let topPage = pages.topPageHandlingClashes(managedObjectContext: self.managedObjectContext) {
            self.page = topPage
        } else {
            fatalError()
        }
    }
    
    /// Reload table view and title of this viewcontroller.
    private func reloadViews() {
        DispatchQueue.main.async {
            self.title = self.page?.name
            self.tableV.reloadData()
        }
    }
}

// MARK: Page Manipulation
extension WorkspaceVC {
    
    private func choosePageToMoveTo() {
        self.present(UINavigationController(rootViewController: WorkspaceVC(workspaceAccessible: self)), animated: true, completion: nil)
    }
    
    private func moveThisPageUnder(_ newParent: Page) {
        guard let thisPage = self.page else {return}
        
        thisPage.moveTo(under: newParent, cannotMoveAction: {
            DispatchQueue.main.async {
                self.present(UIAlertController.cannotMovePage(), animated: true, completion: nil)
            }
        })
        managedObjectContext.saveContext(completion: {
            self.standardReloadProcedure()
        })
    }
}
*/
