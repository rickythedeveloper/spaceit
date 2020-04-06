//
//  IntroEachPageVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 01/04/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

class IntroEachPageVC: UIViewController {
    
    private let text: String
    private let picName: String
    private let startButton: UIButton?
    
    /// startButton should be non-nil only if you want to show the start button
    init(text: String, picName: String, startButton: UIButton? = nil) {
        self.text = text
        self.picName = picName
        self.startButton = startButton
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: set up
private extension IntroEachPageVC {
    
    func setup() {
        let padding: CGFloat = 10.0
        
        let pic = UIImageView(image: UIImage(named: picName))
        pic.translatesAutoresizingMaskIntoConstraints = false
        pic.contentMode = .scaleAspectFit
        view.addSubview(pic)
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        
        pic.constrainToTopSafeAreaOf(view, padding: padding)
        pic.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        pic.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.9).isActive = true
        pic.alignToCenterXOf(view)
        
        label.isBelow(pic, padding: padding)
        label.alignToCenterXOf(view)
        label.widthAnchor.constraint(lessThanOrEqualToConstant: 400.0).isActive = true
        label.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -padding*2).isActive = true
        
        if let startButton = startButton {
            view.addSubview(startButton)
            startButton.isBelow(label, padding: padding)
            startButton.constrainToSideSafeAreasOf(view, padding: padding)
            startButton.constrainToBottomSafeAreaOf(view, padding: padding)
        } else {
            label.constrainToBottomSafeAreaOf(view)
        }
    }
}

// MARK: static funcs
extension IntroEachPageVC {
    static func cards() -> IntroEachPageVC {
        let text =
        """
        All the cards can be seen in the Cards tab. Due cards are showin in red, and you can tap on any card to edit its details.
        """
        
        let picName = "Intro_cards"
        return IntroEachPageVC(text: text, picName: picName)
    }
    
    static func workspace() -> IntroEachPageVC {
        let text =
        """
        You can set up your own tree structure to to categorise your cards. You can add cards and sub-categories to any category. Sky's the limit!
        """
        
        let picName = "intro_workspace"
        return IntroEachPageVC(text: text, picName: picName)
    }
    
    /// startAction should be non-nil only if you want to show the start button on this page
    static func addingCard(startAction: Selector? = nil) -> IntroEachPageVC {
        let text =
        """
        You can add a card from either Cards or Workspace tab. A new card will be due in 24 hours and you will get a notification if you allow it.
        """
        let picName = "intro_add_card"
        
        
        if let action = startAction {
            let startButton = UIButton()
            startButton.setTitle("Start", for: .normal)
            startButton.addTarget(nil, action: action, for: .touchUpInside)
            startButton.layer.cornerRadius = 10.0
            startButton.backgroundColor = .systemGray
            startButton.translatesAutoresizingMaskIntoConstraints = false
            return IntroEachPageVC(text: text, picName: picName, startButton: startButton)
        }
        
        return IntroEachPageVC(text: text, picName: picName)
    }
    
//    static func subscription() -> IntroEachPageVC {
//        let text =
//        """
//        We are always working to make this app better for our users. We offer this app as a very affordable subscription service with a free trial because we believe that our users should be given some time to decide whether it is a good value for money.You can cancel any time. We thank you for considering using our app and hope you enjoy it!
//        """
//
//        let picName = "intro_sub"
//        return IntroEachPageVC(text: text, picName: picName)
//    }
}
