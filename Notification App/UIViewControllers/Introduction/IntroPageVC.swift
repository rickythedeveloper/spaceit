//
//  IntroPageVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 31/03/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

class IntroPageVC: UIPageViewController {
    
    var pages = [UIViewController]()
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageController()
    }
}

private extension IntroPageVC {
    func setupPageController() {
        delegate = self
        dataSource = self
        
        let vc = IntroEachPageVC.cards()
        pages.append(vc)
        
        let vc2 = IntroEachPageVC.workspace()
        pages.append(vc2)
        
        let vc3 = IntroEachPageVC.subscription()
        pages.append(vc3)
        
        setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
    }
}

extension IntroPageVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        for n in 0..<pages.count {
            if pages[n] == viewController {
                if n == 0 {
                    return nil
                } else {
                    return pages[n-1]
                }
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        for n in 0..<pages.count {
            if pages[n] == viewController {
                if n == pages.count-1 {
                    return nil
                } else {
                    return pages[n+1]
                }
            }
        }
        return nil
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return index
    }
}
