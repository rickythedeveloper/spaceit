//
//  WorkspaceViewController+ColumnManagement.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 31/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import FinderViewController

extension WorkspaceViewController: FinderViewDelegate, FinderViewDataSource {
    func widthConstraint(for finderColumn: FinderColumn) -> NSLayoutConstraint {
        var multiplier: CGFloat
        if let _ = finderColumn.columnTableView {
            multiplier = tableWidth
        } else {
            multiplier = detailWidth
        }
        return finderColumn.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: multiplier)
    }
    
    func setContainerWidth(viewWidth: CGFloat) {
        if viewWidth < 600 {
            tableWidth = 1
            detailWidth = 1
        } else if viewWidth < 900 {
            tableWidth = 1/2
            detailWidth = 1/2
        } else if viewWidth < 1200{
            tableWidth = 1/3
            detailWidth = 2/3
        } else {
            tableWidth = 1/4
            detailWidth = 2/4
        }
    }
    
    func finderViewController(_ finderViewController: FinderViewController, didMoveSelectionHorizontallyTo highlightedColumnIndex: Int) {
        self.reloadSelectionColors()
    }
    
    func setPaging() {
        self.scrollView.isPagingEnabled = tableWidth == 1.0 && detailWidth == 1.0
    }
}
