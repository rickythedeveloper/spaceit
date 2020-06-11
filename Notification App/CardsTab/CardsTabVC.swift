//
//  CardsTabVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 22/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import FinderViewController
import CoreData

class CardsTabVC: FinderViewController {
    let managedObjectContext = NSManagedObjectContext.defaultContext()
    
    var listWidth: CGFloat = 1.0
    var detailWidth: CGFloat = 1.0
    
    override init() {
        super.init()
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewWidthUpdated(width: self.view.frame.width)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        viewWidthUpdated(width: size.width)
    }
}

extension CardsTabVC {
    private func initialSetup() {
        let cardsListVC = CardsListVC()
        cardsListVC.cardsTabVC = self
        let cardsNavC = UINavigationController(rootViewController: cardsListVC)
        let column = FinderColumn(finderViewController: self, viewController: cardsNavC, finderTableView: cardsListVC.tableView)
        self.appendColumn(finderColumn: column, animationInterval: 0.0, completion: {})
        
        (self.selectionColor, self.semiSelectionColor) = UIColor.tableViewSelectionColors()
    }
    
    private func viewWidthUpdated(width: CGFloat) {
        setContainerWidth(viewWidth: width)
        updateColumnWidthConstraints()
        setPaging()
    }
    
    func newCardButtonPressed() {
        let vc = NewCardVC()
        let newCardVC = UINavigationController(rootViewController: vc)
        let column = FinderColumn(finderViewController: self, viewController: newCardVC)
        vc.finderColumn = column
        self.removeSecondColumnAndAdd(column: column)
    }
    
    func showCardDetail(card: TaskSaved) {
        let vc = CardEditVC(task: card, managedObjectContext: managedObjectContext, onDismiss: {})
        let navVC = UINavigationController(rootViewController: vc)
        let column = FinderColumn(finderViewController: self, viewController: navVC)
        vc.finderColumn = column
        self.removeSecondColumnAndAdd(column: column)
    }
    
    func removeSecondColumnAndAdd(column: FinderColumn) {
        self.removeColumn(under: 1, animationDuration: 0, completion: {
            self.appendColumn(finderColumn: column, animationInterval: 0, completion: {
                self.showColumn(column, on: .trailingSide, completion: {})
            })
        })
    }
    
    private func setPaging() {
        self.scrollView.isPagingEnabled = listWidth == 1.0 && detailWidth == 1.0
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func setContainerWidth(viewWidth: CGFloat) {
        if viewWidth < 600 {
            listWidth = 1
            detailWidth = 1
        } else if viewWidth < 900 {
            listWidth = 1/2
            detailWidth = 1/2
        } else if viewWidth < 1200{
            listWidth = 1/3
            detailWidth = 2/3
        } else {
            listWidth = 2/4
            detailWidth = 2/4
        }
    }
}

extension CardsTabVC: FinderViewDelegate, FinderViewDataSource {
    func widthConstraint(for finderColumn: FinderColumn) -> NSLayoutConstraint {
        var multiplier: CGFloat
        if finderColumn.columnIndex == 0 {
            multiplier = listWidth
        } else {
            multiplier = detailWidth
        }
        return finderColumn.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: multiplier)
    }
    
    func finderViewController(_ finderViewController: FinderViewController, didMoveSelectionHorizontallyTo highlightedColumnIndex: Int) {
        self.reloadSelectionColors()
    }
}
