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
        navBar.backgroundColor = .red
        container.navigationBar = navBar
        container.layout()
        return container
    }
}
