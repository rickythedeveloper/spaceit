//
//  UITextView+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 22/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension UITextView {
    static func cardSIdeTV() -> UITextView {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.tvBackground()
        tv.font = UIFont.preferredFont(forTextStyle: .title3)
        tv.layer.cornerRadius = 10
        tv.layer.masksToBounds = true
        tv.layer.borderColor = UIColor.myTextColor().withAlphaComponent(0.2).cgColor
        tv.layer.borderWidth = 1
        return tv
    }
}
