//
//  CardFinderVC+Factory.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 16/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import RickyFramework

extension CardFinderVC {
    func newContainerViewForList() -> FinderContainerView {
        let tableView = FinderTableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: searchTFCellID)
        for cardSort in CardSortingSyetem.allCases {
            tableView.register(cardSort.cellClass(), forCellReuseIdentifier: cardSort.rawValue)
        }
        
        let container = FinderContainerView(finderTableView: tableView, navigationBar: nil, finderVC: self)
        
        let navBar = UINavigationBar()
        navBar.barTintColor = .myBackGroundColor()
        container.navigationBar = navBar
        
        let navItem1 = UINavigationItem()
        navItem1.titleView = UIImageView.logoIV()
        navItem1.searchController = self.searchController
        
        let sortToggle = UIButton.myButton(text: self.sortSystem.text(), textColor: .systemBlue, target: self, action: #selector(switchSortSystem(button:)), font: nil, backgroundColor: UIColor.systemGray.withAlphaComponent(0.2), borderColor: nil, borderWidth: nil, cornerRadius: 5.0, contentInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        navItem1.leftBarButtonItem = UIBarButtonItem(customView: sortToggle)
        
        let newCardButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(newCardButtonTapped))
        navItem1.rightBarButtonItem = newCardButton
        
        navBar.setItems([navItem1], animated: true)
        
        container.backgroundColor = .myBackGroundColor()
        container.layout()
        
        return container
    }
}
