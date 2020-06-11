//
//  NewVersionInfoV.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 08/04/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

class NewVersionInfoV: UIView {
    let containerV = UIView()
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    let animationDuration = 0.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(superview: UIView) {
        self.init(frame: .zero)
        addToSuperview(superview)
        setupVersionSpecificInfo()
        setupViews()
        addConstraints()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NewVersionInfoV {
    func setupVersionSpecificInfo() {
        titleLabel.text =
        """
        space it 3.0
        """
        
        messageLabel.text =
        """
        - There have been major UI changes in the app. Workspace now adapts a Finder style experience that lets you get to a particular page more quickly, especially on iPads.
        
        - Cards will now be saved as you edit in real time.
        
        - We have disabled keyboard shortcuts for now. It will be coming back in future updates!
        
        Let us know what you think. Your feedback is vital! Happy Spacing!
        """
    }
}

private extension NewVersionInfoV {
    func setupViews() {
        containerV.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerV)
        containerV.addSubview(titleLabel)
        containerV.addSubview(messageLabel)
        
        containerV.backgroundColor = (UIColor.systemGray3).withAlphaComponent(0.9)
        containerV.layer.cornerRadius = 20.0
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        
        messageLabel.numberOfLines = 0
    }
    
    func addConstraints() {
        let padding: CGFloat = 20.0
        
        NSLayoutConstraint.activate([
            containerV.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.8),
            containerV.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.8),
            
            titleLabel.topAnchor.constraint(equalTo: containerV.topAnchor, constant: padding),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            messageLabel.bottomAnchor.constraint(equalTo: containerV.bottomAnchor, constant: -padding),
        ])
        NSLayoutConstraint.activate(containerV.constraintsToAlignCenter(with: self))
        NSLayoutConstraint.activate(titleLabel.constraintsToFitSides(within: containerV.safeAreaLayoutGuide, padding: padding))
        NSLayoutConstraint.activate(messageLabel.constraintsToFitSides(within: containerV, padding: padding))
    }
    
    func setupAction() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismiss)))
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.dismiss)))
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.alpha = 0
        })
        
        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { (timer) in
            self.removeFromSuperview()
        }
    }
}

extension NewVersionInfoV {
    func addToSuperview(_ superview: UIView) {
        superview.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = (UIColor.systemGray3).withAlphaComponent(0.5)
        self.alpha = 0.0
        
        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.alpha = 1
        })
    }
}
