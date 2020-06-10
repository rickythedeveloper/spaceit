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
    var viewRefreshTimer: Timer?
    
    // Keyboard guardian
    weak var columnTableViewForTappedNewPageTextField: ColumnTableView?
    var viewsToGuard = [UIView]()
    var paddingForKeyboardGuardian: CGFloat  = 10.0
    
    // Workspace Accessible
    var workspaceAccessible: WorkspaceAccessible? // when accessed by another view controller
    
    override init() {
        super.init()
        self.delegate = self
        self.dataSource = self
    }
    
    convenience init(workspaceAccessible: WorkspaceAccessible? = nil) {
        self.init()
        self.workspaceAccessible = workspaceAccessible
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

extension WorkspaceViewController {
    private func initialSetup() {
        let pages = Array.pagesFetched(managedObjectContext: managedObjectContext)
        guard pages.count > 0 else {return}
        guard let topPage = pages.topPageHandlingClashes() else {return}
        let column = columnFor(page: topPage)
        self.appendColumn(finderColumn: column, animationInterval: 0, completion: {})
        
        self.addKeyboardObserver()
        
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataObjectsDidChange), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
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
    
    @objc func coreDataObjectsDidChange() {
        viewRefreshTimer?.invalidate()
        viewRefreshTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { (timer) in
            self.reloadAllColumnTables(completion: {})
        })
    }
    
    private func viewWidthUpdated(width: CGFloat) {
        setContainerWidth(viewWidth: width)
        updateColumnWidthConstraints()
        setPaging()
    }
}
