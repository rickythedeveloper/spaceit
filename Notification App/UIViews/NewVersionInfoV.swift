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
        New in Version 2.1
        """
        
        messageLabel.text =
        """
        - We now support auto-save when editing a card. Whenever leaving the editing page, the card information will automatically be saved.
        
        - We have replaced the "Save" button with a "Discard Changes" button in the editing page.
        
        - Keyboard shortcuts for selecting a card as well as other shortcuts that were introduced in version 2.0! Long-press command to check the shortcuts you can use in that view.
        
        - Minor bug fixes on UI
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
        
        containerV.backgroundColor = (UIColor.systemGray3).withAlphaComponent(0.95)
        containerV.layer.cornerRadius = 20.0
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        
        messageLabel.numberOfLines = 0
    }
    
    func addConstraints() {
        let padding: CGFloat = 10.0
        
        containerV.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.8).isActive = true
        containerV.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.8).isActive = true
        containerV.alignToCenterYOf(self)
        containerV.alignToCenterXOf(self)
        
        titleLabel.topAnchor.constraint(equalTo: containerV.topAnchor, constant: padding).isActive = true
        titleLabel.constrainToSideSafeAreasOf(containerV, padding: padding)
        
        messageLabel.isBelow(titleLabel, padding: padding)
        messageLabel.constrainToSideSafeAreasOf(containerV, padding: padding)
        messageLabel.bottomAnchor.constraint(equalTo: containerV.bottomAnchor, constant: -padding).isActive = true
    }
    
    func setupAction() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismiss)))
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.dismiss)))
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        }, completion: { (completed) in
            self.removeFromSuperview()
        })
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
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
        })
    }
}
