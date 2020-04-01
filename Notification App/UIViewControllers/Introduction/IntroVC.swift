//
//  IntroVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 31/03/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

class IntroVC: UIViewController {
    
    var onDismiss: Selector?
    
    let logo = UIImageView(image: UIImage(named: "logo_2.0"))
    var pageVC = UIPageViewController()
    
    init(onDismiss: Selector? = nil) {
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupViews()
        addConstraints()
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            self.moveLogoUp()
        }
    }
}

// MARK: initial setups
extension IntroVC {
    private func createViews() {
        
    }
    
    private func addViews() {
        view.addSubview(logo)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.myBackGroundColor()
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFit
    }
    
    private func addConstraints() {
        view.addConstraints(firstLogoConstraints())
    }
    
    private func firstLogoConstraints() -> [NSLayoutConstraint] {
        [logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        logo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        logo.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.5),
        logo.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.5)]
    }
    
    private func afterLogoConstraints() -> [NSLayoutConstraint] {
        [logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15.0),
        logo.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.3),
        logo.heightAnchor.constraint(lessThanOrEqualTo: logo.widthAnchor, multiplier: 428/1931)]
    }
}

// MARK: transition to intro
private extension IntroVC {
    func moveLogoUp() {
        view.removeConstraints(firstLogoConstraints())
        view.addConstraints(afterLogoConstraints())
        
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.setupPageVC()
        })
    }
    
    func setupPageVC() {
        let pageVC = IntroPageVC(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        pageVC.view.alpha = 0
        self.addChild(pageVC)
        self.view.addSubview(pageVC.view)
        
        pageVC.view.isBelow(self.logo, padding: 10.0)
        pageVC.view.constrainToSideSafeAreasOf(self.view)
        pageVC.view.constrainToBottomSafeAreaOf(self.view)
        
        UIView.animate(withDuration: 1.0) {
            pageVC.view.alpha = 1
        }
    }
}
