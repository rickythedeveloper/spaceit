//
//  CardEditVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 04/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension UIButton {
    fileprivate static func actionButton(imageName: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: imageName), for: .normal)
        let config = UIImage.SymbolConfiguration(scale: .large)
        button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        return button
    }
}

extension UILabel {
    fileprivate static func text(str: String) -> UILabel {
        let lbl = UILabel()
        lbl.text = str
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }
}

extension UITextView {
    fileprivate static func cardSIdeTV() -> UITextView {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .systemGray3
        tv.alpha = 0.5
        tv.layer.cornerRadius = 10
        tv.layer.masksToBounds = true
        return tv
    }
}

class CardEditVC: UIViewController {
    
    let pageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Hello World", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.sizeToFit()
        return button
    }()
    
    let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .black
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.alpha = 0.5
        return divider
    }()
    
    let frontLabel = UILabel.text(str: "Front")
    
    let frontTextView = UITextView.cardSIdeTV()
    
    let backLabel = UILabel.text(str: "Back")
    
    let backTextView = UITextView.cardSIdeTV()
    
    let deleteButton = UIButton.actionButton(imageName: "trash.circle")
    let deactivateButton = UIButton.actionButton(imageName: "nosign")
    let okButton = UIButton.actionButton(imageName: "checkmark.circle")
    
    var actionButtonContainer = UIStackView()
    
    let statusText = UILabel.text(str: "Status")
    let RIText = UILabel.text(str: "Review interval")
    
    let status = UILabel.text(str: "active")
    let reviewInterval = UILabel.text(str: "15 days")
    
//    var task: TaskSaved
//
//    init(task: TaskSaved) {
//        self.task = task
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemGray
        
        setupViews()
    }
    
    private func setupViews() {
        let padding: CGFloat = 10.0
        let minTVHeight: CGFloat = 1/4
        let maxTVHeight: CGFloat = 1/3
        let minButtonHeight: CGFloat = 30.0
        let maxButtonHeight: CGFloat = 40.0
        
        pageButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        actionButtonContainer = UIStackView(arrangedSubviews: [deleteButton, deactivateButton, okButton])
        actionButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        actionButtonContainer.backgroundColor = .red
        actionButtonContainer.distribution = .fillEqually
        
        view.addSubview(pageButton)
        view.addSubview(divider)
        
        view.addSubview(frontLabel)
        view.addSubview(frontTextView)
        view.addSubview(backLabel)
        view.addSubview(backTextView)
        
        view.addSubview(actionButtonContainer)
        
        pageButton.constrainToTopSafeAreaOf(view)
        pageButton.alignToCenterXOf(view)
        
        divider.topAnchor.constraint(lessThanOrEqualTo: pageButton.bottomAnchor, constant: 10).isActive = true
        divider.constrainToSideSafeAreasOf(view, padding: 2*padding)
        divider.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        frontLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: padding).isActive = true
        frontLabel.constrainToLeadingSafeAreaOf(view, padding: padding)
        
        frontTextView.topAnchor.constraint(lessThanOrEqualTo: frontLabel.bottomAnchor, constant: padding).isActive = true
        frontTextView.constrainToSideSafeAreasOf(view, padding: padding)
        frontTextView.heightAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: minTVHeight).isActive = true
        frontTextView.heightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: maxTVHeight).isActive = true
        
        backLabel.topAnchor.constraint(equalTo: frontTextView.bottomAnchor, constant: padding).isActive = true
        backLabel.constrainToLeadingSafeAreaOf(view, padding: padding)
        
        backTextView.topAnchor.constraint(lessThanOrEqualTo: backLabel.bottomAnchor, constant: padding).isActive = true
        backTextView.constrainToSideSafeAreasOf(view, padding: padding)
        backTextView.heightAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: minTVHeight).isActive = true
        backTextView.heightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: maxTVHeight).isActive = true
        
        actionButtonContainer.topAnchor.constraint(equalTo: backTextView.bottomAnchor, constant: padding).isActive = true
        actionButtonContainer.constrainToSideSafeAreasOf(view, padding: padding)
        actionButtonContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: minButtonHeight).isActive = true
        actionButtonContainer.heightAnchor.constraint(lessThanOrEqualToConstant: maxButtonHeight).isActive = true
        
//        let textVStack = UIStackView(arrangedSubviews: [statusText, RIText])
//        let infoVStack = UIStackView(arrangedSubviews: [status, reviewInterval])
//        let bottomHStack = UIStackView(arrangedSubviews: [textVStack, infoVStack])
//        
//        textVStack.axis = .vertical
//        textVStack.distribution = .fillEqually
//        textVStack.alignment = .trailing
//        
//        infoVStack.axis = .vertical
//        infoVStack.distribution = .fillEqually
//        infoVStack.alignment = .leading
//        
//        bottomHStack.axis = .horizontal
//        bottomHStack.distribution = .fillProportionally
//        bottomHStack.alignment = .center
//        
//        view.addSubview(bottomHStack)
//        
//        bottomHStack.topAnchor.constraint(equalTo: actionButtonContainer.bottomAnchor, constant: padding).isActive = true
//        bottomHStack.constrainToSideSafeAreasOf(view, padding: padding)
//        bottomHStack.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
//        
//        textVStack.trailingAnchor.constraint(equalTo: bottomHStack.centerXAnchor).isActive = true
//        textVStack.widthAnchor.constraint(equalTo: bottomHStack.widthAnchor).isActive = true
//        textVStack.heightAnchor.constraint(equalTo: bottomHStack.heightAnchor).isActive = true
//        infoVStack.leadingAnchor.constraint(equalTo: bottomHStack.centerXAnchor).isActive = true
//        infoVStack.widthAnchor.constraint(equalTo: bottomHStack.widthAnchor).isActive = true
//        infoVStack.heightAnchor.constraint(equalTo: bottomHStack.heightAnchor).isActive = true
        
        
        
        
    }
    
    @objc private func buttonPressed() {
        print("show page structure now")
    }
}
