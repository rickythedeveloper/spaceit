//
//  NewCardVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 22/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import CoreData

class NewCardVC: UIViewController, UITextViewDelegate, WorkspaceAccessible {
    
    private var managedObjectContext: NSManagedObjectContext?
    
    internal let pageButton = UIButton.pageButton(text: "Select page for this button", action: #selector(addPagePressed), usesAutoLayout: true)
    internal var chosenPage: Page?
    
    private let frontLabel = UILabel.front()
    private let frontTV = UITextView.cardSIdeTV()
    private let frontPlaceholder = "Front text"
    private let backLabel = UILabel.back()
    private let backTV = UITextView.cardSIdeTV()
    private let backPlaceholder = "Back text"
    
    private var tvMaxY: CGFloat = 0.0
    
    private let firstDueLabel = UILabel.text(str: "Due in:")
    
    private let addButton = UIButton.actionButton(text: "Add Card", action: #selector(addButtonPressed), backgroundColor: UIColor.pageButtonBackground(), usesAutoLayout: true)
    
    convenience init(prechosenPage: Page? = nil) {
        self.init()
        self.chosenPage = prechosenPage
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.frontTV.becomeFirstResponder()
    }
}

extension NewCardVC {
    @objc private func addPagePressed() {
        self.present(UINavigationController(rootViewController: WorkspaceVC(workspaceAccessible: self)), animated: true, completion: nil)
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
        self.navigationController?.popViewController(animated: true)
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
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = min(0, keyboardSize.minY - tvMaxY)
        }
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
            self.pageButton.setTitle(self.chosenPage?.name, for: .normal)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureDetectedOnView)))
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureDetectedOnView)))
        
        view.addSubview(pageButton)
        view.addSubview(frontLabel)
        view.addSubview(frontTV)
        view.addSubview(backLabel)
        view.addSubview(backTV)
        view.addSubview(addButton)
        
        let padding: CGFloat = 10.0
        let minTVHeight: CGFloat = 1/4
        let maxTVHeight: CGFloat = 1/3
        
        pageButton.constrainToTopSafeAreaOf(view, padding: padding)
        pageButton.alignToCenterXOf(view)
        
        frontLabel.isBelow(pageButton, padding: padding)
        frontLabel.alignToCenterXOf(view)
        
        frontTV.isBelow(frontLabel, padding: padding)
        frontTV.constrainToSideSafeAreasOf(view, padding: padding)
        frontTV.heightAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: minTVHeight).isActive = true
        frontTV.heightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: maxTVHeight).isActive = true
        setupTextView(textView: frontTV)
        
        backLabel.isBelow(frontTV, padding: 3*padding)
        backLabel.alignToCenterXOf(view)

        backTV.isBelow(backLabel, padding: padding)
        backTV.leadingAnchor.constraint(equalTo: frontTV.leadingAnchor).isActive = true
        backTV.trailingAnchor.constraint(equalTo: frontTV.trailingAnchor).isActive = true
        backTV.heightAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: minTVHeight).isActive = true
        backTV.heightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: maxTVHeight).isActive = true
        setupTextView(textView: backTV)
        
        addButton.isBelow(backTV, padding: padding*2)
        addButton.alignToCenterXOf(view)
    }
    
    private func setupTextView(textView: UITextView) {
        textView.text = (textView == frontTV ? frontPlaceholder : backPlaceholder)
        textView.textColor = UIColor.placeholderText
        textView.delegate = self
    }
}
