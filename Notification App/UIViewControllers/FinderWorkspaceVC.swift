//
//  FinderWorkspaceVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 03/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import CoreData
import RickyFramework

class FinderWorkspaceVC: FinderStyleVC {
    let pageSection = 0
    let cardSection = 1
    
    private var topPage: Page?
    private let managedObjectContext = NSManagedObjectContext.defaultContext()
    private var noWorkspaceAlert: UIAlertController?
    
    init(topPage: Page?) {
        super.init()
        self.topPage = topPage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.delegate = self
        standardReloadProcedure()
        
        if UIDevice.current.model == "iPhone" {
            self.scrollView.isPagingEnabled = true
            self.alwaysShowDetail = true
        }
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        standardReloadProcedure()
    }
}

extension FinderWorkspaceVC {
    private func navigationBar(for containerView: FinderStyleContainerView) -> UINavigationBar? {
        if let tableView = containerView.tableView {
            let navBar = UINavigationBar()
            let navItem = UINavigationItem()
            let pageName = UILabel()
            pageName.text = (tableView.information as? Page)?.name
            navItem.titleView = pageName
            if tableView.information as? Page != topPage {
                let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: containerView, action: #selector(containerView.dismiss))
                navItem.leftBarButtonItem = backButton
            }
            navBar.setItems([navItem], animated: true)
            return navBar
        }
        return nil
    }
    
    private func containerView(for tableView: FinderStyleTableView) -> FinderStyleContainerView {
        let containerView = FinderStyleContainerView(finderStyleTableView: tableView, finderStyleVC: self)
        containerView.navigationBar = navigationBar(for: containerView)
        containerView.layout()
        return containerView
    }
}

// MARK: Reloading data and views
extension FinderWorkspaceVC {
    private func standardReloadProcedure() {
        let pages = fetchPages()
        if pages.count == 0 {
            showNoPageAlert()
        } else {
            if topPage == nil {
                findTopPageAndAssignToThisPage(pages: pages)
            }
            reloadViews(reloadsTableViews: true)
            self.noWorkspaceAlert?.dismiss(animated: true, completion: nil)
        }
    }
    
    /// Fetch all the pages in the core data
    private func fetchPages() -> [Page] {
        return Array.pagesFetched(managedObjectContext: managedObjectContext)
    }
    
    /// Show alert asking if the user wants to create a page.
    private func showNoPageAlert() {
        noWorkspaceAlert = UIAlertController.noWorkspaceAlert(createPage: self.noPageSetup)
        self.present(noWorkspaceAlert!, animated: true, completion: nil)
    }
    
    /// GIven an array of pages, this function finds the top page whilst handling clashes and then assifns the top page to this page.
    private func findTopPageAndAssignToThisPage(pages: [Page]) {
        guard pages.count > 0 else {fatalError("The number of pages is 0 where it should not be")}
        if let topPage = pages.topPageHandlingClashes(managedObjectContext: managedObjectContext) {
            self.topPage = topPage
        } else {
            fatalError()
        }
    }
    
    private func noPageSetup() {
        self.topPage = Page.createPageInContext(name: "My Workspace", id: UUID(), context: self.managedObjectContext)
        self.managedObjectContext.saveContext()
        self.standardReloadProcedure()
    }
}

extension FinderWorkspaceVC: FinderStyleVCDelegate {
    func finderStyleFirstContainer() -> FinderStyleContainerView {
        let tableView = newFinderStyleTableView(information: topPage)
        let containerView = FinderStyleContainerView(finderStyleTableView: tableView, finderStyleVC: self)
        containerView.navigationBar = navigationBar(for: containerView)
        containerView.layout()
        return containerView
    }
    
    func finderStyleNextView(for containerView: FinderStyleContainerView, didSelectRowAt indexPath: IndexPath) -> FinderStyleContainerView? {
        guard let tableView = containerView.tableView, let currentPage = tableView.information as? Page else {return nil}
        if indexPath.section == pageSection { // if page section is selected
            if indexPath.row == tableView.numberOfRows(inSection: pageSection) { // if new page cell is selected
                return nil
            } else { // existing page
                let tableView = newFinderStyleTableView(information: currentPage.childrenArray().sortedByName()[indexPath.row])
                return self.containerView(for: tableView)
            }
        } else if indexPath.section == cardSection { // if card section is selected
            if indexPath.row == tableView.numberOfRows(inSection: cardSection) { // if new card is selected
                
            } else { // existing card
                
            }
            return nil
        }
        return nil
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
            return info.numberOfChildren()
        } else if section == cardSection {
            return info.numberOfCards()
        } else {
            return 0
        }
    }
    
    func finderStyleTableView(_ tableView: FinderStyleTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let info = tableView.information as? Page else {return UITableViewCell()}
        if indexPath.section == pageSection {
            let shownPage = info.childrenArray().sortedByName()[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: tableView.cellID, for: indexPath)
            cell.textLabel?.text = shownPage.name
            return cell
        } else if indexPath.section == cardSection {
            let shownCard = info.cardsArray().sortedByCreationDate(oldFirst: true)[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: tableView.cellID, for: indexPath)
            cell.textLabel?.text = shownCard.question
            return cell
        }
        return UITableViewCell()
    }
    
    func widthFor(_ containerView: FinderStyleContainerView) -> CGFloat {
        if UIDevice.current.model == "iPad" {
            if let _ = containerView.tableView {
                return 500.0
            } else if let _ = containerView.customView {
                return 800.0
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
