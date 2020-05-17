//
//  CardFinderVC+SearchController.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 17/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension CardFinderVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        self.updateShownTasks(searchText: searchBar.text ?? "", byPhrase: false)
        self.reloadAllContainerTableViews()
    }
}
