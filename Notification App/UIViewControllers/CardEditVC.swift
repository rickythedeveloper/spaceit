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

//protocol CardEditVCDelegate {
//    func decativatePressed()
//}

class CardEditVC: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        return sv
    }()
    
    let pageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select page for this card", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.sizeToFit()
        button.backgroundColor = (UIColor.systemGray).withAlphaComponent(0.2)
        button.layer.cornerRadius = button.frame.height / 4.0
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return button
    }()
    
    let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .systemGray
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.alpha = 0.5
        return divider
    }()
    
    let frontLabel = UILabel.front()
    
    let frontTextView = UITextView.cardSIdeTV()
    
    let backLabel = UILabel.back()
    
    let backTextView = UITextView.cardSIdeTV()
    
    let deleteButton = UIButton.actionButton(text: "Delete", action: #selector(deletePressed), backgroundColor: .systemRed, backgroundAlpha: 0.7, usesAutoLayout: true)
    let deactivateButton = UIButton.actionButton(text: "Archive", action: #selector(archivePressed), backgroundColor: .systemGray, backgroundAlpha: 0.7, usesAutoLayout: true)
    let okButton = UIButton.actionButton(text: "Save", action: #selector(okPressed), backgroundColor: .systemGreen, backgroundAlpha: 0.7, usesAutoLayout: true)
    
    var actionButtonContainer = UIStackView()
    
    let RIText = UILabel.text(str: "Review interval:", alignment: .right)
    let reviewInterval = UILabel.text(str: "15 days")
    
    var task: TaskSaved
    var managedObjectContext: NSManagedObjectContext
//    var delegate: CardEditVCDelegate?
    
    var onDismiss: () -> Void

    init(task: TaskSaved, managedObjectContext: NSManagedObjectContext, onDismiss: @escaping () -> Void = {}) {
        self.task = task
        self.managedObjectContext = managedObjectContext
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        putCardInfo()
    }
    
    @objc private func buttonPressed() {
        print("show page structure now")
    }
}

extension CardEditVC {
    private func saveCardInfo(completion: @escaping () -> Void = {}) {
        self.task.question = self.frontTextView.text
        self.task.answer = self.backTextView.text
        
        
        self.managedObjectContext.saveContext(completion: {
            completion()
        }, errorHandler: {
            self.present(UIAlertController.saveFailedAlert(), animated: true, completion: nil)
        })
    }
}

extension CardEditVC {
//    func updateView(showsDeactivate: Bool) {
//        if showsDeactivate {
//            deactivateButton.setTitle("Stop Review", for: .normal)
//        } else {
//            deactivateButton.setTitle("Resume Revious", for: .normal)
//        }
//    }
    
    @objc private func deletePressed() {
        
    }
    
    @objc private func archivePressed() {
//        self.delegate?.decativatePressed()
    }
    
    @objc private func okPressed() {
        if !frontTextView.hasText {
            self.present(UIAlertController.noContentAlert(), animated: true) {
                self.frontTextView.becomeFirstResponder()
            }
        } else {
            saveCardInfo(completion: {
                self.navigationController?.popViewController(animated: true)
                self.onDismiss()
            })
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}

extension CardEditVC {
    private func setupViews() {
        let padding: CGFloat = 10.0
        let minTVHeight: CGFloat = 1/4
        let maxTVHeight: CGFloat = 1/3
        let minButtonHeight: CGFloat = 45.0
        let maxButtonHeight: CGFloat = 70.0
        
        self.title = "Edit Card"
        view.backgroundColor = UIColor.myBackGroundColor()
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.constrainToSideSafeAreasOf(view)
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        
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

        scrollView.addSubview(RIText)
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
        
        RIText.isBelow(actionButtonContainer, padding: padding)
        RIText.trailingAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        RIText.constrainToLeadingSafeAreaOf(scrollView, padding: padding)
        RIText.heightAnchor.constraint(lessThanOrEqualToConstant: 40).isActive = true
                 
        reviewInterval.topAnchor.constraint(equalTo: RIText.topAnchor).isActive = true
        reviewInterval.leadingAnchor.constraint(equalTo: RIText.trailingAnchor, constant: padding).isActive = true
        reviewInterval.constrainToTrailingSafeAreaOf(scrollView, padding: padding)
        reviewInterval.heightAnchor.constraint(equalTo: RIText.heightAnchor).isActive = true
        reviewInterval.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor, constant: -padding).isActive = true
    }
    
    private func putCardInfo() {
        frontTextView.text = self.task.question
        backTextView.text = self.task.answer
        reviewInterval.text = self.task.waitTimeString()
    }
}
