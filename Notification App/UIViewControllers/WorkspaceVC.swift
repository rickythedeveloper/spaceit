//
//  WorkspaceVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 31/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import CoreData

class WorkspaceVC: UIViewController {
    
    private var page: Page?
    private var managedObjectContext: NSManagedObjectContext!
    
    init(page: Page? = nil) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        let label = UILabel()
        label.text = self.page?.breadCrumb()
        label.frame = CGRect(x: 100, y: 100, width: 200, height: 100)
        view.addSubview(label)
    }
}

extension WorkspaceVC {
    private func setup() {
        self.managedObjectContext = self.defaultManagedObjectContext()
        
        guard page == nil else {return}
        let pages = self.pagesFetched()
        if pages.count == 0 {
            noPageSetup()
        } else {
            self.page = pages[0].topPage()
        }
    }
    
    private func noPageSetup() {
        self.page = Page.createPageInContext(name: "My Workspace", id: UUID(), context: self.managedObjectContext)
        self.managedObjectContext.saveContext()
    }
}
