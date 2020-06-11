//
//  CardsListVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 22/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import FinderViewController
import CoreData

class CardsListVC: UIViewController {
    let managedObjectContext = NSManagedObjectContext.defaultContext()
    
    var cardsTabVC: CardsTabVC?
    var tableView: ColumnTableView!
    var sortSystem: CardSortingSyetem = .dueDate {
        didSet {
            DispatchQueue.main.async {
                self.updateShownCards(searchText: self.searchController.searchBar.text ?? "", scopeIndex: self.searchController.searchBar.selectedScopeButtonIndex)
                self.tableView.reloadData()
            }
        }
    }
    var shownCards = [TaskSaved]()
    lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search Cards..."
        sc.searchBar.sizeToFit()
        sc.searchBar.searchBarStyle = .prominent
        sc.searchResultsUpdater = self
        sc.searchBar.scopeButtonTitles = [CardSearchSystem.byWholePhrase.text(), CardSearchSystem.bySeperateWords.text()]
        sc.searchBar.delegate = self
        return sc
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        tableView = ColumnTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        initialSetup()
        setupNavigationBar()
        setupTabBar()
    }
}

extension CardsListVC {
    private func initialSetup() {
        updateShownCards(searchText: "", scopeIndex: 0)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        for cardSort in CardSortingSyetem.allCases {
            tableView.register(cardSort.cellClass(), forCellReuseIdentifier: cardSort.rawValue)
        }
        view = tableView
        
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataObjectsDidChange), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.titleView = UIImageView.logoIV()
        let sortToggle = UIButton.myButton(text: self.sortSystem.text(), textColor: .systemBlue, target: self, action: #selector(switchSortSystem(button:)), font: nil, backgroundColor: UIColor.systemGray.withAlphaComponent(0.2), borderColor: nil, borderWidth: nil, cornerRadius: 5.0, contentInsets: UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: sortToggle)
        
        let newCardButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(newCardButtonTapped))
        navigationItem.rightBarButtonItem = newCardButton
        
        navigationController?.navigationBar.barTintColor = .myBackGroundColor()
    }
    
    private func setupTabBar() {
        tabBarController?.tabBar.barTintColor = .myBackGroundColor()
    }
    
    func updateShownCards(searchText: String, scopeIndex: Int) {
        guard searchText.hasContent() else {
            shownCards = sortSystem.taskArray(managedObjectContext: managedObjectContext)
            return
        }
        let searchSystem = CardSearchSystem.system(for: scopeIndex)
        shownCards = searchSystem.filter(tasks: sortSystem.taskArray(managedObjectContext: managedObjectContext), text: searchText)
    }
    
    @objc func switchSortSystem(button: UIButton) {
        sortSystem = sortSystem.next()
        button.setTitle(self.sortSystem.text(), for: .normal)
        button.sizeToFit()
    }
    
    @objc func newCardButtonTapped() {
        cardsTabVC?.newCardButtonPressed()
    }
    
    @objc private func coreDataObjectsDidChange() {
        DispatchQueue.main.async {
            self.updateShownCards(searchText: self.searchController.searchBar.text ?? "", scopeIndex: self.searchController.searchBar.selectedScopeButtonIndex)
            self.tableView.reloadDataSavingSelections()
        }
    }
}

extension CardsListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row >= 0 && indexPath.row < shownCards.count else {return UITableViewCell()}
        let cardIndex = indexPath.row
        
        switch sortSystem {
        case .dueDate:
            if let dueDateCell = tableView.dequeueReusableCell(withIdentifier: sortSystem.rawValue, for: indexPath) as? UpcomingCardListCell {
                dueDateCell.task = shownCards[cardIndex]
                dueDateCell.isFirst = indexPath.row == 0
                return dueDateCell
            }
            break
        case .alphabetical:
            if let alphabeticalCell = tableView.dequeueReusableCell(withIdentifier: sortSystem.rawValue, for: indexPath) as? AlphabeticalCardListCell {
                alphabeticalCell.task = shownCards[cardIndex]
                return alphabeticalCell
            }
            break
        case .creationDate:
            if let creationCell = tableView.dequeueReusableCell(withIdentifier: sortSystem.rawValue, for: indexPath) as? CreationDateCardListCell {
                creationCell.task = shownCards[cardIndex]
                creationCell.isFirst = indexPath.row == 0
                return creationCell
            }
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tableView = tableView as? ColumnTableView else {fatalError()}
        self.cardsTabVC?.highlightedColumnIndex = tableView.columnIndex
        self.cardsTabVC?.showCardDetail(card: shownCards[indexPath.row])
    }
}

extension CardsListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateShownCards(searchText: searchBar.text ?? "", scopeIndex: selectedScope)
        tableView.reloadData()
    }
}

extension CardsListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        updateShownCards(searchText: text, scopeIndex: searchController.searchBar.selectedScopeButtonIndex)
        tableView.reloadData()
    }
}
