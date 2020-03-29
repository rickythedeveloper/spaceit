//
//  ReviewButtonContainerV.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 29/03/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

class ReviewButtonContainerV: UIView {
    
    private var happy = UIButton()
    private var okay = UIButton()
    private var sad = UIButton()
    private var depressed = UIButton()
    private var cancel = UIButton()
    
    private var parentVC: ReviewAccessible?
    
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init(parentVC: ReviewAccessible) {
        self.init(frame: .zero)
        self.parentVC = parentVC
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    private func setupView() {
//        backgroundColor = .red
        self.backgroundColor = UIColor(named: "review_bg")
        self.layer.cornerRadius = 5.0
        translatesAutoresizingMaskIntoConstraints = false
        
        let hStack = UIStackView(arrangedSubviews: [depressed, sad, okay, happy, cancel])
        self.addSubview(hStack)
        
        happy.addTarget(self, action: #selector(happyTapped), for: .touchUpInside)
        happy.setImage(UIImage(named: "happy_face"), for: .normal)
        
        okay.addTarget(self, action: #selector(okayTapped), for: .touchUpInside)
        okay.setImage(UIImage(named: "okay_face"), for: .normal)
        
        sad.addTarget(self, action: #selector(sadTapped), for: .touchUpInside)
        sad.setImage(UIImage(named: "sad_face"), for: .normal)
        
        depressed.addTarget(self, action: #selector(depressedTapped), for: .touchUpInside)
        depressed.setImage(UIImage(named: "depressed_face"), for: .normal)
        
        cancel.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        cancel.setImage(UIImage(named: "review_cancel"), for: .normal)
        
        for subview in hStack.arrangedSubviews as! [UIButton] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            subview.widthAnchor.constraint(equalTo: subview.heightAnchor, multiplier: 0.7).isActive = true
            subview.imageView?.contentMode = .scaleAspectFit
        }
        
        
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .equalSpacing
//        hStack.frame = CGRect(origin: .zero, size: self.frame.size)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.constrainToTopSafeAreaOf(self)
        hStack.constrainToBottomSafeAreaOf(self)
        hStack.constrainToSideSafeAreasOf(self, padding: 10.0)
    }
    
    @objc private func happyTapped() {
        parentVC?.happyAction()
    }
    
    @objc private func okayTapped() {
        parentVC?.okayAction()
    }
    
    @objc private func sadTapped() {
        parentVC?.sadAction()
    }
    
    @objc private func depressedTapped() {
        parentVC?.depressedAction()
    }
    
    @objc private func cancelTapped() {
        parentVC?.cancelAction()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
