//
//  IntroEachPageVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 01/04/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

class IntroEachPageVC: UIViewController {
    
    private let text: String?
    private let picName: String?
    
    init(text: String?, picName: String?) {
        self.text = text
        self.picName = picName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.backgroundColor = .brown
    }
}

// MARK: set up
private extension IntroEachPageVC {
    
    func setup() {
        let padding: CGFloat = 10.0
        
        var pic: UIImageView?
        if let picname = picName {
            pic = UIImageView(image: UIImage(named: picname))
            pic!.translatesAutoresizingMaskIntoConstraints = false
            pic!.contentMode = .scaleAspectFit
            view.addSubview(pic!)
        }
        
        var label: UILabel?
        if let text = text {
            label = UILabel()
            label!.text = text
            label!.font = UIFont.preferredFont(forTextStyle: .body)
            label!.numberOfLines = 0
            label!.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label!)
        }
        
        if let picture = pic, let textLabel = label {
            picture.constrainToTopSafeAreaOf(view, padding: padding)
            picture.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
            picture.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.9).isActive = true
            picture.alignToCenterXOf(view)
            
            textLabel.isBelow(picture, padding: padding)
            textLabel.alignToCenterXOf(view)
            textLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 400.0).isActive = true
            textLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -padding*2).isActive = true
            textLabel.constrainToBottomSafeAreaOf(view)
        } else if let picture = pic {
            picture.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.9).isActive = true
            picture.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.9).isActive = true
            picture.alignToCenterXOf(view)
            picture.alignToCenterYOf(view)
        } else if let textLabel = label {
            textLabel.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.9).isActive = true
            textLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.9).isActive = true
            textLabel.alignToCenterXOf(view)
            textLabel.alignToCenterYOf(view)
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
    
    static func subscription() -> IntroEachPageVC {
        let text =
        """
        We are always working to make this app better for our users. We offer this app as a very affordable subscription service with a free trial. The subscription will enable us to keep this project going.
        """
        
        let picName = "intro_sub"
        return IntroEachPageVC(text: text, picName: picName)
    }
}
