//
//  WorkspaceFinderVC+DataSource.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import RickyFramework

extension WorkspaceFinderVC: FinderVCDataSource {
//    TODO
    func widthConstraint(for containerView: FinderContainerView) -> NSLayoutConstraint {
        if containerView.finderTableView != nil {
            return containerView.widthAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.widthAnchor, multiplier: containerTableWidthMultiplier)
        } else if containerView.customView != nil {
            return containerView.widthAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.widthAnchor, multiplier: customViewWidthMultiplier)
        }
        fatalError()
    }
    
    func numberOfSections(in finderTableView: FinderTableView) -> Int {
        return 2
    }
    
    func finderTableView(_ tableView: FinderTableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Pages"
        default:
            return "Cards"
        }
    }
    
    func finderTableView(_ tableView: FinderTableView, numberOfRowsInSection section: Int) -> Int {
        guard let page = tableView.information as? Page else {return 1}

        switch section {
        case 0:
            return page.numberOfChildren() + 1
        default:
            return page.numberOfCards() + 1
        }
    }
    
    func finderTableView(_ tableView: FinderTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let page = tableView.information as? Page else {return UITableViewCell()}
        
        var cell: UITableViewCell
        if indexPath.section == 0 {
            if indexPath.row < page.numberOfChildren() { // child page cell
                cell = tableView.dequeueReusableCell(withIdentifier: childPageCellID, for: indexPath)
                cell.textLabel?.text = page.childrenArray().sortedByName()[indexPath.row].name
            } else { // new page text field
                cell = tableView.dequeueReusableCell(withIdentifier: newPageCellID, for: indexPath)
                for subview in cell.contentView.subviews {
                    subview.removeFromSuperview()
                }
                
                let textField = WorkspaceNewPageTextField(finderTableView: tableView)
                cell.contentView.addSubview(textField)
                let padding: CGFloat = 5.0
                NSLayoutConstraint.activate(textField.constraintsToFit(within: cell.contentView.safeAreaLayoutGuide, insets: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)))
            }
        } else {
            if indexPath.row < page.numberOfCards() { // child card cell
                cell = tableView.dequeueReusableCell(withIdentifier: childCardCellID, for: indexPath)
                cell.textLabel?.text = page.cardsArray().sortedByCreationDate(oldFirst: true)[indexPath.row].question
            } else { // New card cell
                cell = tableView.dequeueReusableCell(withIdentifier: newCardCellID, for: indexPath)
                if let imageView = cell.imageView {
                    imageView.image = UIImage(systemName: "plus")
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate(imageView.constraintsToFit(within: cell.safeAreaLayoutGuide, insets: .zero))
                    imageView.contentMode = .center
                }
            }
        }
        
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
