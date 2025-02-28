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
    
    var startAction: Selector?
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }
    
    /// startActionForButton should be non-nil only if you want to show the start button on the last page of the intro VC
    convenience init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil, startActionForButton action: Selector? = nil) {
        self.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        self.startAction = action
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageController()
    }
}

private extension IntroPageVC {
    func setupPageController() {
        delegate = self
        dataSource = self
        
        let proxy = UIPageControl.appearance()
        proxy.pageIndicatorTintColor = (UIColor.myTextColor()).withAlphaComponent(0.3)
        proxy.currentPageIndicatorTintColor = (UIColor.myTextColor()).withAlphaComponent(0.7)
        
        let vc = IntroEachPageVC.cards()
        pages.append(vc)
        
        let vc2 = IntroEachPageVC.workspace()
        pages.append(vc2)
        
        let vc3 = IntroEachPageVC.addingCard(startAction: startAction)
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
