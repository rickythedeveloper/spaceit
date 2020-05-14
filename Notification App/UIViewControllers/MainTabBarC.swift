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
    
    private var introVC = IntroVC()
    private let managedObjectContext = NSManagedObjectContext.defaultContext()
    
    override var selectedIndex: Int {
        willSet {
            self.transition(tabBarController: self, to: self.viewControllers?[newValue])
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        // Do any additional setup after loading the view.
        let listTabBarItem = UITabBarItem(title: "Cards", image: UIImage(systemName: "square.stack.3d.up"), tag: 0)
        let cardListNavC = UINavigationController(rootViewController: CardListVC())
        cardListNavC.tabBarItem = listTabBarItem
        
        let workspaceItem = UITabBarItem(title: "Workspace", image: UIImage(systemName: "folder"), tag: 1)
        let workspaceNavC = UINavigationController(rootViewController: WorkspaceVC())
        workspaceNavC.tabBarItem = workspaceItem
        
//        let finderWorkspaceVC = FinderWorkspaceVC(workspaceAccessible: nil)
//        finderWorkspaceVC.tabBarItem = workspaceItem
        let workspaceFinderVC = WorkspaceFinderVC(workspaceAccessible: nil)
        workspaceFinderVC.tabBarItem = workspaceItem
        self.viewControllers = [cardListNavC, workspaceFinderVC]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let isFirstTime = "isFirstTime"
        let hasSeenNewVersionInfo = "hasSeenNewVersionInfo_2.0" // Don't forget to change this.
        
        if defaults.value(forKey: isFirstTime) == nil {
            self.presentIntro(startActionForButton: #selector(dismissIntro))
            defaults.set(true, forKey: isFirstTime)
            defaults.set(true, forKey: hasSeenNewVersionInfo)
        } else if defaults.value(forKey: hasSeenNewVersionInfo) == nil {
            _ = NewVersionInfoV(superview: self.view)
            defaults.set(true, forKey: hasSeenNewVersionInfo)
        }
    }
}

// MARK: Dealing with intro VC
private extension MainTabBarC {
    /// startActionForButton should be non-nil only if you want to show the start button on the last page of the intro VC
    func presentIntro(startActionForButton: Selector? = nil) {
        guard self.presentedViewController == nil else {return}
        introVC = IntroVC(startAction: startActionForButton)
        self.present(introVC, animated: true, completion: nil)
    }
    
    @objc func dismissIntro() {
        guard self.presentedViewController != nil else {return}
        introVC.dismiss(animated: true, completion: nil)
    }
}

// MARK: Switching views
extension MainTabBarC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let _ = selectedViewController?.view, let _ = viewController.view else {
          return false // Make sure you want this as false
        }
        transition(tabBarController: tabBarController, to: viewController)
        return true
    }
    
    func transition(tabBarController: UITabBarController, to viewController: UIViewController?) {
        guard let currentView = tabBarController.selectedViewController?.view, let nextView = viewController?.view else {return}
        
        if currentView != nextView {
            UIView.transition(from: currentView, to: nextView, duration: 0.3, options: [.transitionFlipFromRight], completion: nil)
        }
    }
}

/*
// MARK: Update User info
extension MainTabBarC {
    /// Update the User object from the info received from the IAP receipt. Then set the value for allowsAccessToContent.
    func updateUserInfo() {
        sskw.checkExpiryDate(productIDs: [sskw.monthlySub, sskw.yearlySub]) { (expiryDate) in
            guard let expiry = expiryDate else {return}
            let now = Date()
            let expired = (expiry < now)
            
            if let user = User.latestUserInfo(managedObjectContext: self.managedObjectContext) {
                user.updateInfo(lastUpdated: now, subscriptionExpiryDate: expiry, subscriptionLastVerified: (expired ? nil : now))
            } else { // no valid user info is in the device
                _ = User.createNewUser(lastUpdated: now, subscriptionExpiryDate: expiry, subscriptionLastVerified: (expired ? nil : now), managedObjectContext: self.managedObjectContext)
            }
            
            self.managedObjectContext.saveContext()
            self.allowsAccessToContent = User.userShouldProceedToContent(managedObjectContext: self.managedObjectContext)
        }
    }
}
*/
