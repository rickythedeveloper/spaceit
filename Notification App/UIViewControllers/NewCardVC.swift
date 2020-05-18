//
//  NewCardVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 22/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import CoreData
import RickyFramework

class NewCardVC: UIViewController, UITextViewDelegate, WorkspaceAccessible {
    unowned var finderContainerView: FinderContainerView?
    private var managedObjectContext: NSManagedObjectContext?
    var allowsKeyCommands: Bool = false {
        willSet {
            if newValue == true {frontTV.becomeFirstResponder()}
        }
    }
    
    private var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let pageButton = UIButton.pageButton(text: "Select page for this button", action: #selector(addPagePressed), usesAutoLayout: true)
    internal var chosenPage: Page? {
        willSet(newPage) {
            if newPage == nil {
                pageButton.setTitle("Select page for this button", for: .normal)
            } else {
                pageButton.setTitle(newPage!.breadCrumb(), for: .normal)
            }
        }
    }
    
    private let frontLabel = UILabel.front()
    let frontTV = UITextView.cardSIdeTV()
    private let frontPlaceholder = "Front text"
    private let backLabel = UILabel.back()
    private let backTV = UITextView.cardSIdeTV()
    private let backPlaceholder = "Back text"
    
    private var tvMaxY: CGFloat = 0.0
    
    private let firstDueLabel = UILabel.text(str: "Due in:")
    
    private let addButton = UIButton.actionButton(text: "Add Card", action: #selector(addButtonPressed), backgroundColor: UIColor.pageButtonBackground(), usesAutoLayout: true)
    
    convenience init(prechosenPage: Page? = nil, finderContainerView: FinderContainerView? = nil) {
        self.init()
        self.chosenPage = prechosenPage
        self.finderContainerView = finderContainerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension NewCardVC {
    @objc private func addPagePressed() {
//        self.present(UINavigationController(rootViewController: WorkspaceVC(workspaceAccessible: self)), animated: true, completion: nil)
    }
    
    @objc private func goToNextTextView() {
        if self.frontTV.isFirstResponder {
            self.backTV.becomeFirstResponder()
        } else if self.backTV.isFirstResponder {
            self.addButtonPressed()
        } else {
            self.frontTV.becomeFirstResponder()
        }
    }
    
    @objc private func previousTF() {
        if self.backTV.isFirstResponder {
            self.frontTV.becomeFirstResponder()
        } else if self.frontTV.isFirstResponder {
            self.frontTV.resignFirstResponder()
        } else {
            self.backTV.becomeFirstResponder()
        }
    }
    
    @objc private func addButtonPressed() {
        guard frontTV.text.hasContent() && !showingPlaceholder(textView: frontTV) else {
            self.present(UIAlertController.noContentAlert(), animated: true, completion: nil)
            return
        }
        
        guard let context = self.managedObjectContext else {return}
        
        let task = TaskSaved(context: context)
        task.id = UUID()
        task.question = frontTV.text
        
        if backTV.text.hasContent() && !showingPlaceholder(textView: backTV) {
            task.answer = backTV.text
        } else {
            task.answer = nil
        }
        
        task.lastChecked = Date()
        task.waitTime = 60*60*24
        task.page = self.chosenPage
        task.isActive = true
        task.createdAt = Date()
        
        context.saveContext()
        self.registerNotification(id: task.id, question: task.question, waitTime: task.waitTime)
        
        self.clearTextsForTVs()
        dismissView()
    }
    
    @objc private func dismissView() {
        if let containerView = finderContainerView {
            containerView.dismiss(completion: {})
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func registerNotification(id: UUID, question: String, waitTime: TimeInterval) {
        let nc = UNUserNotificationCenter.current()
        nc.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                nc.sendSRTaskNotification(id: id, question: question, waitTime: waitTime)
            default:
                nc.requestAuthorization(options: [.alert]) { (granted, error) in
                    if !granted, let error = error {
                        fatalError(error.localizedDescription)
                    } else {
                        nc.sendSRTaskNotification(id: id, question: question, waitTime: waitTime)
                    }
                }
            }
        }
    }
    
    private func clearTextsForTVs() {
        for each in [frontTV, backTV] {
            self.setPlaceholder(textView: each)
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        tvMaxY = textView.frame.maxY
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = nil
            textView.textColor = UIColor.myTextColor()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setPlaceholder(textView: textView)
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}

        var textFieldMaxY: CGFloat = 0.0

        if self.frontTV.isFirstResponder {
            textFieldMaxY = (self.frontTV.superview!.convert(frontTV.frame, to: nil)).maxY
        } else if self.backTV.isFirstResponder {
            textFieldMaxY = (self.backTV.superview!.convert(backTV.frame, to: nil)).maxY
        }

        self.scrollView.setContentOffset(CGPoint(x: 0, y: max(-self.scrollView.contentInset.top, 10 + textFieldMaxY - keyboardSize.minY)), animated: true)
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    private func setPlaceholder(textView: UITextView) {
        if textView == frontTV {
            textView.text = frontPlaceholder
        } else if textView == backTV {
            textView.text = backPlaceholder
        }
        textView.textColor = UIColor.placeholderText
    }
    
    @objc private func gestureDetectedOnView() {
        view.endEditing(true)
    }
    
    private func showingPlaceholder(textView: UITextView) -> Bool {
        return textView.textColor == UIColor.placeholderText
    }
}

extension NewCardVC {
    private func setup() {
        self.managedObjectContext = NSManagedObjectContext.defaultContext()
        
        self.title = "New Flashcard"
        self.view.backgroundColor = UIColor.myBackGroundColor()
        if self.chosenPage != nil {
            self.pageButton.setTitle(self.chosenPage?.breadCrumb(), for: .normal)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate(scrollView.constraintsToFit(within: view.safeAreaLayoutGuide, insets: .zero))
        scrollView.delegate = self
        
        scrollView.addSubview(pageButton)
        scrollView.addSubview(frontLabel)
        scrollView.addSubview(frontTV)
        scrollView.addSubview(backLabel)
        scrollView.addSubview(backTV)
        scrollView.addSubview(addButton)
        
        let padding: CGFloat = 10.0
        let minTVHeight: CGFloat = 1/4
        let maxTVHeight: CGFloat = 1/3
        
        pageButton.layoutPageSelectButton(parentView: scrollView, padding: padding)
        setupTextView(textView: frontTV)
        setupTextView(textView: backTV)
        
        NSLayoutConstraint.activate([
            frontLabel.topAnchor.constraint(equalTo: pageButton.bottomAnchor, constant: padding),
            frontLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

            frontTV.topAnchor.constraint(equalTo: frontLabel.bottomAnchor, constant: padding),
            frontTV.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            frontTV.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            frontTV.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.safeAreaLayoutGuide.heightAnchor, multiplier: minTVHeight),
            frontTV.heightAnchor.constraint(lessThanOrEqualTo: scrollView.safeAreaLayoutGuide.heightAnchor, multiplier: maxTVHeight),

            backLabel.topAnchor.constraint(equalTo: frontTV.bottomAnchor, constant: padding*3),
            backLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

            backTV.topAnchor.constraint(equalTo: backLabel.bottomAnchor, constant: padding),
            backTV.leadingAnchor.constraint(equalTo: frontTV.leadingAnchor),
            backTV.trailingAnchor.constraint(equalTo: frontTV.trailingAnchor),
            backTV.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.safeAreaLayoutGuide.heightAnchor, multiplier: minTVHeight),
            backTV.heightAnchor.constraint(lessThanOrEqualTo: scrollView.safeAreaLayoutGuide.heightAnchor, multiplier: maxTVHeight),

            addButton.topAnchor.constraint(equalTo: backTV.bottomAnchor, constant: padding*2),
            addButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -padding)
        ])
    }
    
    private func setupTextView(textView: UITextView) {
        textView.text = (textView == frontTV ? frontPlaceholder : backPlaceholder)
        textView.textColor = UIColor.placeholderText
        textView.delegate = self
    }
}

// MARK: Scrollview delegate
extension NewCardVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// MARK: Keyboard Shortcuts
extension NewCardVC {
    override var keyCommands: [UIKeyCommand]? {
        if allowsKeyCommands {
            return [
                UIKeyCommand(title: "Cancel", action: #selector(dismissView), input: "b", modifierFlags: [.command, .alternate], discoverabilityTitle: "Cancel"),
                UIKeyCommand(title: "Select Page For New Card", action: #selector(addPagePressed), input: "p", modifierFlags: [.command, .alternate], discoverabilityTitle: "Select Page For New Card"),
                
                UIKeyCommand(title: "Next Field / Save", action: #selector(goToNextTextView), input: "\r", modifierFlags: [.command], discoverabilityTitle: "Next Field / Save"),
                UIKeyCommand(title: "Previous Field", action: #selector(previousTF), input: "\r", modifierFlags: [.command, .shift], discoverabilityTitle: "Previous Field"),
            ]
        }
        return nil
    }
}

extension NewCardVC {
    func newContainerView(finderVC: FinderVC) -> FinderContainerView {
        let navbar = UINavigationBar()
        let navItem = UINavigationItem(title: "Add Flashcard")
        navbar.setItems([navItem], animated: true)
        navbar.barTintColor = .myBackGroundColor()
        let container = FinderContainerView(customViewController: self, navigationBar: navbar, finderVC: finderVC)
        container.layout()
        self.finderContainerView = container
        return container
    }
}
