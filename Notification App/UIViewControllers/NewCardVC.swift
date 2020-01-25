//
//  NewCardVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 22/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

class NewCardVC: UIViewController, UITextViewDelegate {
    
    private let pageButton = UIButton.pageButton(text: "Select page for this button", action: #selector(addPagePressed), usesAutoLayout: true)
    
    private let frontLabel = UILabel.front()
    private let frontTV = UITextView.cardSIdeTV()
    private let frontPlaceholder = "Front text"
    private let backLabel = UILabel.back()
    private let backTV = UITextView.cardSIdeTV()
    private let backPlaceholder = "Back text"
    
    private var tvMaxY: CGFloat = 0.0
    
    private let firstDueLabel = UILabel.text(str: "Due in:")
    
    private let addButton = UIButton.actionButton(text: "Add Card", action: #selector(addButtonPressed), backgroundColor: UIColor.pageButtonBackground(), usesAutoLayout: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
}

extension NewCardVC {
    @objc private func addPagePressed() {
        print("show pages now")
    }
    
    @objc private func addButtonPressed() {
        print("add card now")
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = min(0, keyboardSize.minY - tvMaxY)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
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
}

extension NewCardVC {
    private func setup() {
        self.title = "New Flashcard"
        self.view.backgroundColor = UIColor.myBackGroundColor()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
