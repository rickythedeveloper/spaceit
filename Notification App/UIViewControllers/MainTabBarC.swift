//
//  MainTabBarC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 11/02/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

class MainTabBarC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let listTabBarItem = UITabBarItem(title: "Cards", image: UIImage(systemName: "square.stack.3d.up"), tag: 0)
        let cardListNavC = UINavigationController(rootViewController: CardListVC())
        cardListNavC.tabBarItem = listTabBarItem
        
        let workspaceItem = UITabBarItem(title: "Workspace", image: UIImage(systemName: "folder"), tag: 1)
        let workspaceNavC = UINavigationController(rootViewController: WorkspaceVC())
        workspaceNavC.tabBarItem = workspaceItem
        self.viewControllers = [cardListNavC, workspaceNavC]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
