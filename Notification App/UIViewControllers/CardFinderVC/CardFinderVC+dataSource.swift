//
//  CardFinderVC+dataSource.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 16/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import RickyFramework

extension CardFinderVC: FinderVCDataSource {
    func widthConstraint(for containerView: FinderContainerView) -> NSLayoutConstraint {
        if let _ = containerView.finderTableView {
            return containerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: containerTableWidthMultiplier)
        } else if let _ = containerView.customViewController as? CardEditVC {
            return containerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: customViewWidthMultiplier)
        } else if let _ = containerView.customViewController as? NewCardVC {
            return containerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: customViewWidthMultiplier)
        }
        fatalError()
    }
    
    func finderTableView(_ tableView: FinderTableView, numberOfRowsInSection section: Int) -> Int {
        return shownTasks.count
    }
    
    func finderTableView(_ tableView: FinderTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < shownTasks.count else {fatalError()}
        
        let cardIndex = indexPath.row
        
        var cell: UITableViewCell?
        switch sortSystem {
        case .dueDate:
            if let dueDateCell = tableView.dequeueReusableCell(withIdentifier: sortSystem.rawValue, for: indexPath) as? UpcomingCardListCell {
                dueDateCell.isFirst = indexPath.row == 0
                dueDateCell.task = shownTasks[cardIndex]
                cell = dueDateCell
            }
            break
        case .alphabetical:
            if let alphabeticalCell = tableView.dequeueReusableCell(withIdentifier: sortSystem.rawValue, for: indexPath) as? AlphabeticalCardListCell {
                alphabeticalCell.task = shownTasks[cardIndex]
                cell = alphabeticalCell
            }
            break
        case .creationDate:
            if let creationCell = tableView.dequeueReusableCell(withIdentifier: sortSystem.rawValue, for: indexPath) as? CreationDateCardListCell {
                creationCell.isFirst = indexPath.row == 0
                creationCell.task = shownTasks[cardIndex]
                cell = creationCell
            }
            break
        }
        
        if let cell = cell {
            return cell
        }
        fatalError()
        
    }
}
