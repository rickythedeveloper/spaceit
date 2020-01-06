//
//  UIButton+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 06/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension UIButton {
    static func actionButton(text: String, action: Selector, font: UIFont? = nil, backgroundColor: UIColor? = nil, backgroundAlpha: CGFloat = 1.0, usesAutoLayout: Bool) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = font
        button.backgroundColor = backgroundColor?.withAlphaComponent(backgroundAlpha)
        button.translatesAutoresizingMaskIntoConstraints = !usesAutoLayout
        button.sizeToFit()
        button.addTarget(nil, action: action, for: .touchUpInside)
        button.layer.cornerRadius = button.layer.frame.height / 4.0
        return button
    }
}
