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

class CardEditVC: UIViewController, UIScrollViewDelegate, WorkspaceAccessible {
    internal var chosenPage: Page?
    
    var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        return sv
    }()
    
    internal let pageButton: UIButton = {
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
        button.addTarget(self, action: #selector(selectPage), for: .touchUpInside)
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
    let reviewButton = UIButton.actionButton(text: "Review", action: #selector(reviewPressed), backgroundColor: .systemBlue, backgroundAlpha: 0.7, usesAutoLayout: true)
    
    var actionButtonContainer = UIStackView()
    lazy var reviewView: ReviewButtonContainerV = { [unowned self] in
        return ReviewButtonContainerV(parentVC: self)
    }()
    
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

// MARK: Core Data
extension CardEditVC {
    private func saveCardInfo(completion: @escaping () -> Void = {}) {
        self.task.question = self.frontTextView.text
        self.task.answer = self.backTextView.text
        if chosenPage != nil {
            self.task.page = chosenPage!
        }
        
        self.managedObjectContext.saveContext(completion: {
            completion()
        }, errorHandler: {
            self.present(UIAlertController.saveFailedAlert(), animated: true, completion: nil)
        })
    }
}

// MARK: Actions
extension CardEditVC {
    
    @objc private func selectPage() {
        self.present(UINavigationController(rootViewController: WorkspaceVC(workspaceAccessible: self)), animated: true, completion: nil)
    }
    
    @objc private func deletePressed() {
        let deleteAlert = UIAlertController.deleteAlert {
            self.managedObjectContext.delete(self.task)
            self.dismissView()
            self.managedObjectContext.saveContext()
        }
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    @objc private func archivePressed() {
        let action = {
            self.task.isActive.toggle()
            self.dismissView()
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
                self.dismissView()
            })
        }
    }
    
    @objc private func reviewPressed() {
        reviewView.alpha = 0.0
        scrollView.addSubview(reviewView)
        reviewView.translatesAutoresizingMaskIntoConstraints = false
        reviewView.constrainToTopSafeAreaOf(actionButtonContainer)
//        reviewView.constrainToBottomSafeAreaOf(actionButtonContainer)
        reviewView.constrainToSideSafeAreasOf(actionButtonContainer)
        reviewView.heightAnchor.constraint(equalToConstant: actionButtonContainer.frame.height).isActive = true
        UIView.animate(withDuration: 0.3) {
            self.reviewView.alpha = 1.0
        }
    }
    
    @objc private func goToNextTextView() {
        if frontTextView.isFirstResponder {
            backTextView.becomeFirstResponder()
        } else {
            okPressed()
        }
    }
    
    @objc private func dismissView() {
        self.navigationController?.popViewController(animated: true)
        self.onDismiss()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}

// MARK: Keyboard Shortcuts
extension CardEditVC {
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(title: "Select page", action: #selector(selectPage), input: "p", modifierFlags: [.command], discoverabilityTitle: "Select page"),
            UIKeyCommand(title: "Delete", action: #selector(deletePressed), input: "d", modifierFlags: [.command], discoverabilityTitle: "Delete"),
            UIKeyCommand(title: "Archive", action: #selector(archivePressed), input: "a", modifierFlags: [.command], discoverabilityTitle: "Archive"),
            UIKeyCommand(title: "Save", action: #selector(okPressed), input: "s", modifierFlags: [.command], discoverabilityTitle: "Save"),
            UIKeyCommand(title: "Next/Save", action: #selector(goToNextTextView), input: "\r", modifierFlags: [.command], discoverabilityTitle: "Next/Save"),
            UIKeyCommand(title: "Go back", action: #selector(dismissView), input: UIKeyCommand.inputLeftArrow, modifierFlags: [.command], discoverabilityTitle: "Go back"),
        ]
    }
}

// MARK: Set Up Views
extension CardEditVC {
    private func setupViews() {
        let padding: CGFloat = 10.0
        let minTVHeight: CGFloat = 1/4
        let maxTVHeight: CGFloat = 1/3
        let minButtonHeight: CGFloat = 50.0
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
        if self.task.page != nil {
            pageButton.setTitle(self.task.page!.name, for: .normal)
        }
        
        actionButtonContainer = UIStackView(arrangedSubviews: [deleteButton, deactivateButton, okButton, reviewButton])
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
        infoStack.constrainToSideSafeAreasOf(scrollView, padding: padding)
        infoStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -padding).isActive = true // this effectively sets the content size of the scrollview
    }
    
    private func putCardInfo() {
        frontTextView.text = self.task.question
        backTextView.text = self.task.answer
        dueDateLabel.text = "Due on " + self.task.dueDateStringShort()
        intervalLabel.text = "Review interval: " + self.task.waitTimeString()
    }
}

extension CardEditVC: ReviewAccessible {
    
    func happyAction() {
        reviewWithEase(4)
    }
    
    func okayAction() {
        reviewWithEase(3)
    }
    
    func sadAction() {
        reviewWithEase(2)
    }
    
    func depressedAction() {
        reviewWithEase(1)
    }
    
    func cancelAction() {
        UIView.animate(withDuration: 0.3, animations: {
            self.reviewView.alpha = 0.0
        }) { (_) in
            self.reviewView.removeFromSuperview()
        }
//        self.reviewView.removeFromSuperview()
    }
    
    private func reviewWithEase(_ ease: Int) {
        self.task.reviewed(ease: ease)
        self.managedObjectContext.saveContext()
        self.registerNotification(task: self.task)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func registerNotification(task: TaskSaved) {
        let nc = UNUserNotificationCenter.current()
        nc.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                nc.sendSRTaskNotification(task: task)
            default:
                nc.requestAuthorization(options: [.alert]) { (granted, error) in
                    if !granted, let error = error {
                        fatalError(error.localizedDescription)
                    } else {
                        nc.sendSRTaskNotification(task: task)
                    }
                }
            }
        }
    }
}
