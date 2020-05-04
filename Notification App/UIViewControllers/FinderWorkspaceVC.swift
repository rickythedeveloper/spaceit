//
//  FinderWorkspaceVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 03/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import CoreData
import RickyFramework

class FinderWorkspaceVC: FinderStyleVC {
    let pageSection = 0
    let cardSection = 1
    
    var topPage: Page?
    let managedObjectContext = NSManagedObjectContext.defaultContext()
    var noWorkspaceAlert: UIAlertController?
    
    init(topPage: Page?) {
        super.init()
        self.topPage = topPage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.delegate = self
        standardReloadProcedure()
        
        if UIDevice.current.model == "iPhone" {
            self.scrollView.isPagingEnabled = true
            self.alwaysShowDetail = true
        }
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        standardReloadProcedure()
    }
}


