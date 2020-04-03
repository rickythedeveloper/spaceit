//
//  MainTabBarC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 11/02/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import CoreData

class MainTabBarC: UITabBarController {
    
    static let shared = MainTabBarC()
    var allowsAccessToContent: Bool = false {
        willSet {
            if newValue {
                dismissIntro()
            } else {
                presentIntro()
            }
        }
    }
    
    private let introVC = IntroVC()
    private let sskw = SwiftyStoreKitWrapper.shared
    private let managedObjectContext = NSManagedObjectContext.defaultContext()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateUserInfo()

        // Do any additional setup after loading the view.
        let listTabBarItem = UITabBarItem(title: "Cards", image: UIImage(systemName: "square.stack.3d.up"), tag: 0)
        let cardListNavC = UINavigationController(rootViewController: CardListVC())
        cardListNavC.tabBarItem = listTabBarItem
        
        let workspaceItem = UITabBarItem(title: "Workspace", image: UIImage(systemName: "folder"), tag: 1)
        let workspaceNavC = UINavigationController(rootViewController: WorkspaceVC())
        workspaceNavC.tabBarItem = workspaceItem
        self.viewControllers = [cardListNavC, workspaceNavC]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !allowsAccessToContent {
            presentIntro()
        }
    }
}

// MARK: Dealing with intro VC
private extension MainTabBarC {
    func setup() {
        introVC.isModalInPresentation = true
    }
    
    func presentIntro() {
        self.present(introVC, animated: true, completion: nil)
    }
    
    func dismissIntro() {
        introVC.dismiss(animated: true, completion: nil)
    }
}

// MARK: Update User info
extension MainTabBarC {
    /// Update the User object from the info received from the IAP receipt. Then set the value for allowsAccessToContent.
    func updateUserInfo() {
        sskw.checkExpiryDate(productIDs: [sskw.monthlySub, sskw.yearlySub]) { (expiryDate) in
            guard let expiry = expiryDate else {return}
            if let user = User.latestUserInfo(managedObjectContext: self.managedObjectContext) {
                user.updateInfo(lastUpdated: Date(), subscriptionExpiryDate: expiry, subscriptionLastVerified: Date())
            } else { // no valid user info is in the device
                _ = User.createNewUser(lastUpdated: Date(), subscriptionExpiryDate: expiry, subscriptionLastVerified: Date(), managedObjectContext: self.managedObjectContext)
                self.managedObjectContext.saveContext()
            }
            
            if User.userShouldProceedToContent(managedObjectContext: self.managedObjectContext) {
                self.allowsAccessToContent = true
            } else {
                self.allowsAccessToContent = false
            }
        }
    }
}
