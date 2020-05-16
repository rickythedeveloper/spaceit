//
//  CardFinderVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 16/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import RickyFramework
import CoreData

class CardFinderVC: FinderVC {
    let managedObjectContext = NSManagedObjectContext.defaultContext()
    let searchTFCellID = "searchTFCellID"
    
    var sortSystem: CardSortingSyetem = .creationDate {
        didSet {
            reloadTableView()
        }
    }
    var allTasks = [TaskSaved]()
    var containerTableWidthMultiplier: CGFloat = 1
    var customViewWidthMultiplier: CGFloat = 1
    var searchTextField: UITextField = {
        let tf = UITextField.roundPaddedTextField(usesAutolayout: true)
        tf.backgroundColor = .tvBackground()
        tf.placeholder = "Search"
        return tf
    }()
    var coreDataTimer: Timer?
    
    override init() {
        super.init()
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        start()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setContainerWidth(viewWidth: view.frame.width)
        updateContainerWidth()
    }
}

extension CardFinderVC {
    func setup() {
        view.backgroundColor = .myBackGroundColor()
        allTasks = sortSystem.taskArray(managedObjectContext: managedObjectContext)
        updatePagingSetting()
        
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataObjectsDidChange), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        
        let listContainer = newContainerViewForList()
        addContainerView(listContainer)
    }
}
