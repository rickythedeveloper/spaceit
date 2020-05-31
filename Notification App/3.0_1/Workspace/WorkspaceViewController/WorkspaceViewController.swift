//
//  WorkspaceViewController.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 31/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import FinderViewController
import RickyFramework
import CoreData

class WorkspaceViewController: FinderViewController, KeyboardGuardian {
    let managedObjectContext = NSManagedObjectContext.defaultContext()
    
    var tableWidth: CGFloat = 1.0
    var detailWidth: CGFloat = 1.0
    var horizontalKeyCommandsEnabled: Bool = true
    
    // Keyboard guardian
    weak var columnTableViewForTappedNewPageTextField: ColumnTableView?
    var viewsToGuard = [UIView]()
    var paddingForKeyboardGuardian: CGFloat  = 10.0
    
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
        setContainerWidth(viewWidth: self.view.frame.width)
        updateColumnWidthConstraints()
        setPaging()
    }
}

extension WorkspaceViewController {
    private func initialSetup() {
        let pages = Array.pagesFetched(managedObjectContext: managedObjectContext)
        guard pages.count > 0 else {return}
        guard let topPage = pages.topPageHandlingClashes() else {return}
        let column = columnFor(page: topPage)
        self.appendColumn(finderColumn: column, animationInterval: 0, completion: {})
        
        self.addKeyboardObserver()
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        if let changeInOffset = offsetDueToKeyboard(keyboardNotification: notification), let columnTableView = columnTableViewForTappedNewPageTextField {
            let finalOffset = CGPoint(x: 0, y: max(columnTableView.contentOffset.y + changeInOffset.y, columnTableView.contentOffset.y))
            columnTableView.setContentOffset(finalOffset, animated: true)
        }
    }
    
    /// Updates the information required for the keyboard guardian to work. Call this just before the keyboard shows.
    func updateKeyboardGuardianInformation(_ textField: WorkspaceNewPageTF, inside columnTableView: ColumnTableView) {
        viewsToGuard = [textField]
        columnTableViewForTappedNewPageTextField = columnTableView
    }
}
