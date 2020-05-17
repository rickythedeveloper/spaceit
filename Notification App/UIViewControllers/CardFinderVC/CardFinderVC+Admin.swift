//
//  CardFinderVC+Admin.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 16/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension CardFinderVC {
    func setContainerWidth(viewWidth: CGFloat) {
        if viewWidth < 600 {
            containerTableWidthMultiplier = 1
            customViewWidthMultiplier = 1
        } else if viewWidth < 900 {
            containerTableWidthMultiplier = 1/2
            customViewWidthMultiplier = 1/2
        } else if viewWidth < 1200{
            containerTableWidthMultiplier = 1/3
            customViewWidthMultiplier = 2/3
        } else {
            containerTableWidthMultiplier = 1/4
            customViewWidthMultiplier = 3/4
        }
    }
    
    func updatePagingSetting() {
        scrollView.isPagingEnabled = (customViewWidthMultiplier == 1 && containerTableWidthMultiplier == 1) // paging should be enabled if the container width multiplier is one
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setContainerWidth(viewWidth: size.width)
        updateContainerWidth()
        updatePagingSetting()
        print("view will transisino")
    }
    
    @objc func coreDataObjectsDidChange() {
        // This will prevent the table view from reloading too often, which lowers the performance.
        coreDataTimer?.invalidate()
        coreDataTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            self.reloadTableView()
        })
    }
    
    func reloadTableView(completion: @escaping () -> Void = {}) {
        allTasks = sortSystem.taskArray(managedObjectContext: managedObjectContext)
        updateShownTasks(searchText: self.searchController.searchBar.text ?? "", byPhrase: false)
        DispatchQueue.main.async {
            self.reloadAllContainerTableViews()
            completion()
        }
    }
    
    func updateShownTasks(searchText: String, byPhrase: Bool) {
        guard searchText.hasContent() else {
            shownTasks = allTasks
            return
        }
        
        let keywords = searchText.seperatedWords()
        shownTasks = byPhrase ? allTasks.filterByWord(searchPhrase: searchText) : allTasks.filterByKeywords(keywords)
    }
    
    @objc func switchSortSystem(button: UIButton) {
        sortSystem = sortSystem.next()
        button.setTitle(self.sortSystem.text(), for: .normal)
    }
}
