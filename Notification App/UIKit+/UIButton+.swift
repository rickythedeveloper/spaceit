//
//  UIButton+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 06/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension UIButton {
    static func actionButton(text: String = "", action: Selector, font: UIFont? = nil, backgroundColor: UIColor? = nil, backgroundAlpha: CGFloat? = nil, usesAutoLayout: Bool) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = font
        button.setTitleColor(.myTextColor(), for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.sizeToFit()
        if let alpha = backgroundAlpha {
            button.backgroundColor = backgroundColor?.withAlphaComponent(alpha)
        } else {
            button.backgroundColor = backgroundColor
        }
        button.translatesAutoresizingMaskIntoConstraints = !usesAutoLayout
        button.sizeToFit()
        button.addTarget(nil, action: action, for: .touchUpInside)
        button.layer.cornerRadius = button.layer.frame.height / 4.0
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }
    
    static func pageButton(text: String, action: Selector, usesAutoLayout: Bool) -> UIButton {
        let button = UIButton.actionButton(text: text, action: action, font: UIFont.preferredFont(forTextStyle: .callout), backgroundColor: UIColor.pageButtonBackground(), usesAutoLayout: usesAutoLayout)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        return button
    }
    
    func layoutPageSelectButton(parentView: UIView, padding: CGFloat) {
        self.isBelow(parentView.topAnchor, padding: padding)
        self.alignToCenterXOf(parentView)
        self.widthAnchor.constraint(lessThanOrEqualTo: parentView.widthAnchor, constant: -padding*2.0).isActive = true
        if self.titleLabel != nil {
            self.heightAnchor.constraint(equalTo: self.titleLabel!.heightAnchor, constant: padding).isActive = true
        }
    }
}
