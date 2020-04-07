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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.saveCardInfo()
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
            let sv = self.savedView()
            self.view.addSubview(sv)
            sv.alignToCenterYOf(self.view)
            sv.alignToCenterXOf(self.view)
            sv.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
            sv.alpha = 0.0
            UIView.animate(withDuration: 0.2, animations: {
                sv.alpha = 1.0
            }, completion: { _ in
                DispatchQueue.main.async {
                    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
                        completion()
                    }
                }
            })
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
        }
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    @objc private func archivePressed() {
        let action = {
            self.task.isActive.toggle()
            self.dismissView()
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
            self.dismissView()
        }
    }
    
    @objc  private func discardChangesPressed() {
        let discardAlert = UIAlertController.discardChangesAlert {
            self.putCardInfo()
        }
        self.present(discardAlert, animated: true, completion:  nil)
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// MARK: Keyboard Shortcuts
extension CardEditVC {
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(title: "Go back", action: #selector(dismissView), input: UIKeyCommand.inputLeftArrow, modifierFlags: [.command], discoverabilityTitle: "Go back"),
            UIKeyCommand(title: "Select page", action: #selector(selectPage), input: "p", modifierFlags: [.command], discoverabilityTitle: "Select page"),
            UIKeyCommand(title: "Next/Save", action: #selector(goToNextTextView), input: "\r", modifierFlags: [.command], discoverabilityTitle: "Next/Save"),
            UIKeyCommand(title: "Delete", action: #selector(deletePressed), input: "d", modifierFlags: [.command], discoverabilityTitle: "Delete"),
            UIKeyCommand(title: "Archive/Recover", action: #selector(archivePressed), input: "a", modifierFlags: [.command], discoverabilityTitle: "Archive/Recover"),
            UIKeyCommand(title: "Save", action: #selector(okPressed), input: "s", modifierFlags: [.command], discoverabilityTitle: "Save"),
            UIKeyCommand(title: "Review: Very Hard", action: #selector(depressedAction), input: "1", modifierFlags: [.command], discoverabilityTitle: "Review: Very Hard"),
            UIKeyCommand(title: "Review: Hard", action: #selector(sadAction), input: "2", modifierFlags: [.command], discoverabilityTitle: "Review: Hard"),
            UIKeyCommand(title: "Review: Easy", action: #selector(okayAction), input: "3", modifierFlags: [.command], discoverabilityTitle: "Review: Easy"),
            UIKeyCommand(title: "Review: Very Easy", action: #selector(happyAction), input: "4", modifierFlags: [.command], discoverabilityTitle: "Review: Very Easy"),
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        view.backgroundColor = UIColor.myBackGroundColor()
        view.addSubview(scrollView)
        
        navigationItem.rightBarButtonItems = [discardChangesButtonItem(), archiveButtonItem(), deleteButtonItem()]
        
        scrollView.constrainToTopSafeAreaOf(view)
        scrollView.constrainToSideSafeAreasOf(view)
        scrollView.constrainToBottomSafeAreaOf(view)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        
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
        self.chosenPage = self.task.page
        frontTextView.text = self.task.question
        backTextView.text = self.task.answer
        dueDateLabel.text = "Due on " + self.task.dueDateStringShort()
        intervalLabel.text = "Review interval: " + self.task.waitTimeString()
    }
}

extension CardEditVC: ReviewAccessible {
    
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
    
    func cancelAction() {
        UIView.animate(withDuration: 0.3, animations: {
            self.reviewView.alpha = 0.0
        }) { (_) in
            self.reviewView.removeFromSuperview()
        }
    }
    
    private func reviewWithEase(_ ease: Int) {
        self.task.reviewed(ease: ease)
        self.registerNotification(task: self.task)
        self.dismissView()
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
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        var textFieldMaxY: CGFloat = 0.0
        
        if self.frontTextView.isFirstResponder {
            textFieldMaxY = (self.frontTextView.superview!.convert(frontTextView.frame, to: nil)).maxY
        } else if self.backTextView.isFirstResponder {
            textFieldMaxY = (self.backTextView.superview!.convert(backTextView.frame, to: nil)).maxY
        }
        
        self.scrollView.setContentOffset(CGPoint(x: 0, y: max(-self.scrollView.contentInset.top, 10 + textFieldMaxY - keyboardSize.minY)), animated: true)
    }
}

// MARK: Navigation Bar Items
extension CardEditVC {
    private func deleteButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deletePressed))
        
    }
    private func archiveButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: "archivebox"), style: .plain, target: self, action: #selector(archivePressed))
    }
    
    private func discardChangesButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: "rectangle.fill.badge.xmark"), style: .plain, target: self, action: #selector(discardChangesPressed))
    }
}

// MARK: Saved View
extension CardEditVC {
    private func savedView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = (UIColor.systemGray3).withAlphaComponent(0.7)
        view.layer.cornerRadius = 10.0
        
        let image = UIImage(systemName: "checkmark")
        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Saved"
        label.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [iv, label])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5.0
        
        view.addSubview(stack)
        
        view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        iv.widthAnchor.constraint(equalTo: label.widthAnchor).isActive = true
        
        stack.alignToCenterXOf(view)
        stack.alignToCenterYOf(view)
        stack.heightAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        stack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.9).isActive = true
        
        return view
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
