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
    let deactivateButton = UIButton.actionButton(text: "", action: #selector(archivePressed), backgroundColor: .systemGray, backgroundAlpha: 0.7, usesAutoLayout: true)
    let okButton = UIButton.actionButton(text: "Save", action: #selector(okPressed), backgroundColor: .systemGreen, backgroundAlpha: 0.7, usesAutoLayout: true)
    
    var actionButtonContainer = UIStackView()
    
    let dueDateLabel = UILabel()
    let intervalLabel = UILabel()
    let infoStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var task: TaskSaved
    var managedObjectContext: NSManagedObjectContext
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        deactivateButton.setTitle(self.task.isActive ? "Archive" : "Recover", for: .normal)
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
    @objc private func deletePressed() {
        let deleteAlert = UIAlertController.deleteAlert {
            self.managedObjectContext.delete(self.task)
            self.navigationController?.popViewController(animated: true)
            self.managedObjectContext.saveContext()
        }
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    @objc private func archivePressed() {
        let action = {
            self.task.isActive.toggle()
            self.navigationController?.popViewController(animated: true)
            self.managedObjectContext.saveContext()
        }
        let alert = self.task.isActive ? UIAlertController.archiveAlert(action: action) : UIAlertController.recoverAlert(action: action)
        self.present(alert, animated: true, completion: nil)
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
        
        dueDateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        intervalLabel.font = UIFont.preferredFont(forTextStyle: .body)
        infoStack.addArrangedSubview(dueDateLabel)
        infoStack.addArrangedSubview(intervalLabel)
        infoStack.axis = .vertical
        infoStack.alignment = .center
        infoStack.distribution = .equalSpacing
        infoStack.spacing = padding/2.0
        
        scrollView.addSubview(pageButton)
        scrollView.addSubview(divider)

        scrollView.addSubview(frontLabel)
        scrollView.addSubview(frontTextView)
        scrollView.addSubview(backLabel)
        scrollView.addSubview(backTextView)

        scrollView.addSubview(actionButtonContainer)
        scrollView.addSubview(infoStack)
        
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
        
        infoStack.isBelow(actionButtonContainer, padding: padding)
        infoStack.constrainToSideSafeAreasOf(self.view, padding: padding)
    }
    
    private func putCardInfo() {
        frontTextView.text = self.task.question
        backTextView.text = self.task.answer
        dueDateLabel.text = "Due on " + self.task.dueDateStringShort()
        intervalLabel.text = "Review interval: " + self.task.waitTimeString()
    }
}
