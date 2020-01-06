//
//  CardEditVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 04/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import SwiftUI
import CoreData

extension UILabel {
    fileprivate static func text(str: String, alignment: NSTextAlignment = .left, color: UIColor? = nil, alpha: CGFloat = 1.0) -> UILabel {
        let lbl = UILabel()
        lbl.text = str
        lbl.textAlignment = alignment
        lbl.textColor = color
        lbl.alpha = alpha
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

protocol CardEditVCDelegate {
    func decativatePressed()
}

class CardEditVC: UIViewController {
    
    var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        return sv
    }()
    
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
        divider.backgroundColor = .systemGray
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.alpha = 0.5
        return divider
    }()
    
    let frontLabel = UILabel.text(str: "Front")
    
    let frontTextView = UITextView.cardSIdeTV()
    
    let backLabel = UILabel.text(str: "Back")
    
    let backTextView = UITextView.cardSIdeTV()
    
    let deleteButton = UIButton.actionButton(text: "Delete", action: #selector(deletePressed), backgroundColor: .systemRed, backgroundAlpha: 0.7, usesAutoLayout: true)
    let deactivateButton = UIButton.actionButton(text: "Deactivate", action: #selector(deactivatePressed), backgroundColor: .systemGray, backgroundAlpha: 0.7, usesAutoLayout: true)
    let okButton = UIButton.actionButton(text: "Save", action: #selector(okPressed), backgroundColor: .systemGreen, backgroundAlpha: 0.7, usesAutoLayout: true)
    
    var actionButtonContainer = UIStackView()
    
    let statusText = UILabel.text(str: "Status:", alignment: .right)
    let RIText = UILabel.text(str: "Review interval:", alignment: .right)
    
    let status = UILabel.text(str: "Active", color: .red)
    let reviewInterval = UILabel.text(str: "15 days")
    
    var task: TaskSaved
    var managedObjectContext: NSManagedObjectContext
    var delegate: CardEditVCDelegate?

    init(task: TaskSaved, managedObjectContext: NSManagedObjectContext) {
        self.task = task
        self.managedObjectContext = managedObjectContext
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @objc private func buttonPressed() {
        print("show page structure now")
    }
}

extension CardEditVC {
    func updateView(showsDeactivate: Bool) {
        if showsDeactivate {
            deactivateButton.setTitle("Deactivate", for: .normal)
        } else {
            deactivateButton.setTitle("Reactivate", for: .normal)
        }
    }
    
    @objc private func deletePressed() {
        
    }
    
    @objc private func deactivatePressed() {
        self.delegate?.decativatePressed()
    }
    
    @objc private func okPressed() {
        
    }
}

extension CardEditVC {
    private func setupViews() {
        let padding: CGFloat = 10.0
        let minTVHeight: CGFloat = 1/4
        let maxTVHeight: CGFloat = 1/3
        let minButtonHeight: CGFloat = 30.0
        let maxButtonHeight: CGFloat = 40.0
        
        scrollView.frame = view.safeAreaLayoutGuide.layoutFrame
        view.addSubview(scrollView)
        
        pageButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        actionButtonContainer = UIStackView(arrangedSubviews: [deleteButton, deactivateButton, okButton])
        actionButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        actionButtonContainer.backgroundColor = .red
        actionButtonContainer.distribution = .fillEqually
        actionButtonContainer.spacing = padding
        
        scrollView.addSubview(pageButton)
        scrollView.addSubview(divider)

        scrollView.addSubview(frontLabel)
        scrollView.addSubview(frontTextView)
        scrollView.addSubview(backLabel)
        scrollView.addSubview(backTextView)

        scrollView.addSubview(actionButtonContainer)

        scrollView.addSubview(statusText)
        scrollView.addSubview(RIText)
        scrollView.addSubview(status)
        scrollView.addSubview(reviewInterval)
        
        pageButton.isBelow(scrollView.topAnchor, padding: padding)
        pageButton.alignToCenterXOf(scrollView)
        
        divider.topAnchor.constraint(lessThanOrEqualTo: pageButton.bottomAnchor, constant: 10).isActive = true
        divider.constrainToSideSafeAreasOf(scrollView, padding: 2*padding)
        divider.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        frontLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: padding).isActive = true
        frontLabel.constrainToLeadingSafeAreaOf(scrollView, padding: padding)
        
        frontTextView.topAnchor.constraint(lessThanOrEqualTo: frontLabel.bottomAnchor, constant: padding).isActive = true
        frontTextView.constrainToSideSafeAreasOf(scrollView, padding: padding)
        frontTextView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.safeAreaLayoutGuide.heightAnchor, multiplier: minTVHeight).isActive = true
        frontTextView.heightAnchor.constraint(lessThanOrEqualTo: scrollView.safeAreaLayoutGuide.heightAnchor, multiplier: maxTVHeight).isActive = true
        
        backLabel.topAnchor.constraint(equalTo: frontTextView.bottomAnchor, constant: padding).isActive = true
        backLabel.constrainToLeadingSafeAreaOf(scrollView, padding: padding)
        
        backTextView.topAnchor.constraint(lessThanOrEqualTo: backLabel.bottomAnchor, constant: padding).isActive = true
        backTextView.constrainToSideSafeAreasOf(scrollView, padding: padding)
        backTextView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.safeAreaLayoutGuide.heightAnchor, multiplier: minTVHeight).isActive = true
        backTextView.heightAnchor.constraint(lessThanOrEqualTo: scrollView.safeAreaLayoutGuide.heightAnchor, multiplier: maxTVHeight).isActive = true
        
        actionButtonContainer.topAnchor.constraint(equalTo: backTextView.bottomAnchor, constant: padding).isActive = true
        actionButtonContainer.constrainToSideSafeAreasOf(scrollView, padding: padding)
        actionButtonContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: minButtonHeight).isActive = true
        actionButtonContainer.heightAnchor.constraint(lessThanOrEqualToConstant: maxButtonHeight).isActive = true
        
        
        statusText.topAnchor.constraint(equalTo: actionButtonContainer.bottomAnchor).isActive = true
        statusText.trailingAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        statusText.constrainToLeadingSafeAreaOf(scrollView, padding: padding)
        statusText.heightAnchor.constraint(lessThanOrEqualToConstant: 40).isActive = true
        
        RIText.topAnchor.constraint(equalTo: statusText.bottomAnchor).isActive = true
        RIText.trailingAnchor.constraint(equalTo: statusText.trailingAnchor).isActive = true
        RIText.constrainToLeadingSafeAreaOf(scrollView, padding: padding)
        RIText.heightAnchor.constraint(lessThanOrEqualToConstant: 40).isActive = true
        
        status.topAnchor.constraint(equalTo: statusText.topAnchor).isActive = true
        status.leadingAnchor.constraint(equalTo: statusText.trailingAnchor, constant: padding).isActive = true
        status.constrainToTrailingSafeAreaOf(scrollView, padding: padding)
        status.heightAnchor.constraint(equalTo: statusText.heightAnchor).isActive = true
         
        reviewInterval.topAnchor.constraint(equalTo: RIText.topAnchor).isActive = true
        reviewInterval.leadingAnchor.constraint(equalTo: status.leadingAnchor).isActive = true
        reviewInterval.constrainToTrailingSafeAreaOf(scrollView, padding: padding)
        reviewInterval.heightAnchor.constraint(equalTo: RIText.heightAnchor).isActive = true
    }
}
