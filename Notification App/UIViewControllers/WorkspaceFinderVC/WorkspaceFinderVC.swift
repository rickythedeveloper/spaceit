//
//  WorkspaceFinderVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

//import Foundation
import RickyFramework
import CoreData

class WorkspaceFinderVC: FinderVC, KeyboardGuardian {
    
    let pageSection = 0
    let cardSection = 1
    let managedObjectContext = NSManagedObjectContext.defaultContext()
    
    let childPageCellID = "childPageCellID"
    let newPageCellID = "newPageCellID"
    let childCardCellID = "childCardCellID"
    let newCardCellID = "newCardCellID"
    
    var topPage: Page?
    var workspaceAccessible: WorkspaceAccessible?
    var noWorkspaceAlert: UIAlertController?
    var containerTableWidthMultiplier: CGFloat = 1.0
    var customViewWidthMultiplier: CGFloat = 1.0
    var coreDataTimer: Timer?
    
    // Keyboard guardian
    var finderTableViewForTappedNewPageTextField: FinderTableView?
    var viewsToGuard = [UIView]()
    var paddingForKeyboardGuardian: CGFloat  = 10.0
    
    init(topPage: Page? = nil, workspaceAccessible: WorkspaceAccessible?) {
        super.init()
        self.topPage = topPage
        self.workspaceAccessible = workspaceAccessible
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.start()
        self.setContainerWidth(viewWidth: self.view.frame.width)
        self.reloadAllViews(completion: {})
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataObjectsDidChange), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        self.addKeyboardObserver()
        
        self.view.backgroundColor = .myBackGroundColor()
        scrollView.isPagingEnabled = (customViewWidthMultiplier == 1 && containerTableWidthMultiplier == 1) // paging should be enabled if the container width multiplier is one
    }
}
