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
import RickyFramework
import FinderViewController

class CardEditVC: UIViewController, UIScrollViewDelegate, WorkspaceAccessible, KeyboardGuardian {
    var viewsToGuard = [UIView]()
    var paddingForKeyboardGuardian: CGFloat = 10.0
    var allowsKeyCommands: Bool = false
    
    unowned var finderColumn: FinderColumn?
    
    internal var chosenPage: Page? {
        willSet(newPage) {
            if newPage == nil {
                pageButton.setTitle("Select page for this button", for: .normal)
            } else {
                pageButton.setTitle(newPage!.breadCrumb(), for: .normal)
            }
        }
    }
    
    var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        return sv
    }()
    
    let pageButton = UIButton.pageButton(text: "Select page for this button", action: #selector(selectPage), usesAutoLayout: true)
    
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
    var infoUpdateTimer: Timer?
    
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
    
    deinit {
        print("Card Edit VC is being destroyed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        putCardInfo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        updateCardInfo()
    }
}

// MARK: Core Data
extension CardEditVC {
    private func updateCardInfo() {
        self.task.question = self.frontTextView.text
        self.task.answer = self.backTextView.text
        if chosenPage != nil {
            self.task.page = chosenPage!
        }
        self.managedObjectContext.saveContext()
    }
}

// MARK: Actions
extension CardEditVC {
    
    @objc private func selectPage() {
        
    }
    
    @objc private func deletePressed() {
        let deleteAlert = UIAlertController.deleteAlert {
            self.managedObjectContext.delete(self.task)
            self.dismissView(hidesFirst: true)
        }
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    @objc private func archivePressed() {
        let action = {
            self.task.isActive.toggle()
            self.dismissView(hidesFirst: true)
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
            self.dismissView(hidesFirst: true)
        }
    }
    
    @objc private func goToNextTextView() {
        if frontTextView.isFirstResponder {
            backTextView.becomeFirstResponder()
        } else if backTextView.isFirstResponder {
            okPressed()
        } else {
            frontTextView.becomeFirstResponder()
        }
    }
    
    @objc private func backToPreviousTextView() {
        if frontTextView.isFirstResponder {
            frontTextView.resignFirstResponder()
        } else if backTextView.isFirstResponder {
            frontTextView.becomeFirstResponder()
        } else {
            backTextView.becomeFirstResponder()
        }
    }
    
    @objc private func dismissView(hidesFirst: Bool) {
        if let column = finderColumn {
            column.dismiss(hidesFirst: hidesFirst, removalDuration: 0, completion: {})
        }
        self.onDismiss()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// MARK: Keyboard Shortcuts
//extension CardEditVC {
//    override var keyCommands: [UIKeyCommand]? {
//        if allowsKeyCommands {
//            return [
//                UIKeyCommand(title: "Go back", action: #selector(dismissView), input: "b", modifierFlags: [.command, .alternate], discoverabilityTitle: "Go back"),
//                UIKeyCommand(title: "Select page", action: #selector(selectPage), input: "p", modifierFlags: [.command, .alternate], discoverabilityTitle: "Select page"),
//
//                UIKeyCommand(title: "Next Field / Save", action: #selector(goToNextTextView), input: "\r", modifierFlags: [.command], discoverabilityTitle: "Next Field / Save"),
//                UIKeyCommand(title: "Previous Field", action: #selector(backToPreviousTextView), input: "\r", modifierFlags: [.command, .shift], discoverabilityTitle: "Previous Field"),
//
//                UIKeyCommand(title: "Archive/Recover", action: #selector(archivePressed), input: "a", modifierFlags: [.command, .shift], discoverabilityTitle: "Archive/Recover"),
//                UIKeyCommand(title: "Save", action: #selector(okPressed), input: "s", modifierFlags: [.command, .shift], discoverabilityTitle: "Save"),
//                UIKeyCommand(title: "Delete", action: #selector(deletePressed), input: "d", modifierFlags: [.command, .shift], discoverabilityTitle: "Delete"),
//
//                UIKeyCommand(title: "Review: Very Hard", action: #selector(depressedAction), input: "1", modifierFlags: [.command], discoverabilityTitle: "Review: Very Hard"),
//                UIKeyCommand(title: "Review: Hard", action: #selector(sadAction), input: "2", modifierFlags: [.command], discoverabilityTitle: "Review: Hard"),
//                UIKeyCommand(title: "Review: Easy", action: #selector(okayAction), input: "3", modifierFlags: [.command], discoverabilityTitle: "Review: Easy"),
//                UIKeyCommand(title: "Review: Very Easy", action: #selector(happyAction), input: "4", modifierFlags: [.command], discoverabilityTitle: "Review: Very Easy"),
//            ]
//        }
//        return nil
//    }
//}

// MARK: Set Up Views
extension CardEditVC {
    private func setupViews() {
        let padding: CGFloat = 10.0
        let minTVHeight: CGFloat = 1/4
        let maxTVHeight: CGFloat = 1/3
        let minButtonHeight: CGFloat = 50.0
        let maxButtonHeight: CGFloat = 70.0
        
        self.addKeyboardObserver()
        
        view.backgroundColor = UIColor.myBackGroundColor()
        view.addSubview(scrollView)
        
        navigationItem.rightBarButtonItems = [archiveButtonItem(), deleteButtonItem()]
        
        NSLayoutConstraint.activate(scrollView.constraintsToFit(within: view.safeAreaLayoutGuide, insets: .zero))
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        
        frontTextView.delegate = self
        backTextView.delegate = self
        
        viewsToGuard.append(contentsOf: [frontTextView, backTextView])
        paddingForKeyboardGuardian = padding
        
        actionButtonContainer = reviewButtonStack(spacing: padding)
        
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
        
        pageButton.layoutPageSelectButton(parentView: scrollView, padding: padding)
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(lessThanOrEqualTo: pageButton.bottomAnchor, constant: 10),
            divider.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 2*padding),
            divider.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -2*padding),
            divider.heightAnchor.constraint(equalToConstant: 1.0),
            
            frontLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: padding),
            frontLabel.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            
            frontTextView.topAnchor.constraint(lessThanOrEqualTo: frontLabel.bottomAnchor, constant: padding),
            frontTextView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            frontTextView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            frontTextView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.safeAreaLayoutGuide.heightAnchor, multiplier: minTVHeight),
            frontTextView.heightAnchor.constraint(lessThanOrEqualTo: scrollView.safeAreaLayoutGuide.heightAnchor, multiplier: maxTVHeight),
            
            backLabel.topAnchor.constraint(equalTo: frontTextView.bottomAnchor, constant: padding),
            backLabel.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            
            backTextView.topAnchor.constraint(lessThanOrEqualTo: backLabel.bottomAnchor, constant: padding),
            backTextView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            backTextView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            backTextView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.safeAreaLayoutGuide.heightAnchor, multiplier: minTVHeight),
            backTextView.heightAnchor.constraint(lessThanOrEqualTo: scrollView.safeAreaLayoutGuide.heightAnchor, multiplier: maxTVHeight),
            
            actionButtonContainer.topAnchor.constraint(equalTo: backTextView.bottomAnchor, constant: padding),
            actionButtonContainer.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            actionButtonContainer.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            actionButtonContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: minButtonHeight),
            actionButtonContainer.heightAnchor.constraint(lessThanOrEqualToConstant: maxButtonHeight),
            
            infoStack.topAnchor.constraint(equalTo: actionButtonContainer.bottomAnchor, constant: padding),
            infoStack.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            infoStack.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            infoStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -padding) // this effectively sets the content size of the scrollview
        ])
    }
    
    private func putCardInfo() {
        self.chosenPage = self.task.page
        frontTextView.text = self.task.question
        backTextView.text = self.task.answer
        dueDateLabel.text = "Due on " + self.task.dueDate().dateString()
        intervalLabel.text = "Review interval: " + self.task.waitTimeString()
    }
}

extension CardEditVC {
    
    @objc func happyAction() {
        reviewWithEase(4)
    }
    
    @objc func okayAction() {
        reviewWithEase(3)
    }
    
    @objc func sadAction() {
        reviewWithEase(2)
    }
    
    @objc func depressedAction() {
        reviewWithEase(1)
    }
    
    private func reviewWithEase(_ ease: Int) {
        self.task.reviewed(ease: ease)
        self.registerNotification(task: self.task)
        self.dismissView(hidesFirst: true)
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

// MARK: Keyboard guardian
extension CardEditVC {
    /// Offset the content if needed based on  the keyboard frame.
    func keyboardWillChangeFrame(notification: NSNotification) {
        updateScrollViewOffset(keyboardNotification: notification)
    }
    /// Updates the scroll view content offset depending on the keyboard notification
    func updateScrollViewOffset(keyboardNotification: NSNotification) {
        if let offset = self.offsetDueToKeyboard(keyboardNotification: keyboardNotification) {
            let finalOffset = CGPoint(x: 0, y: max(self.scrollView.contentOffset.y + offset.y, 0))
            self.scrollView.setContentOffset(finalOffset, animated: true)
        }
    }
}

// MARK: Navigation Bar Items
extension CardEditVC {
    func deleteButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deletePressed))
        
    }
    func archiveButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: "archivebox"), style: .plain, target: self, action: #selector(archivePressed))
    }
}

// MARK: Review Button Stack
extension CardEditVC {
    private func reviewButtonStack(spacing: CGFloat) -> UIStackView {
        let veryHard = UIButton.reviewButton(task: task, ease: 1, cardEditVC: self, action: #selector(depressedAction), usesAutolayout: true)
        let hard = UIButton.reviewButton(task: task, ease: 2, cardEditVC: self, action: #selector(sadAction), usesAutolayout: true)
        let okay = UIButton.reviewButton(task: task, ease: 3, cardEditVC: self, action: #selector(okayAction), usesAutolayout: true)
        let easy = UIButton.reviewButton(task: task, ease: 4, cardEditVC: self, action: #selector(happyAction), usesAutolayout: true)
        
        let stack = UIStackView(arrangedSubviews: [veryHard, hard, okay, easy])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = spacing
        
        return stack
    }
}

extension CardEditVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        infoUpdateTimer?.invalidate()
        infoUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            self.updateCardInfo()
        })
    }
}
