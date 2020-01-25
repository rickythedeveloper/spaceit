//
//  UILabel+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 08/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension UILabel {
    public static func text(str: String, alignment: NSTextAlignment = .left, color: UIColor? = nil, alpha: CGFloat = 1.0) -> UILabel {
        let lbl = UILabel()
        lbl.text = str
        lbl.textAlignment = alignment
        lbl.textColor = color
        lbl.alpha = alpha
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }
    
    static func front() -> UILabel {
        return UILabel.text(str: "Front", alignment: .center)
    }
    
    static func back() -> UILabel {
        return UILabel.text(str: "Back", alignment: .center)
    }
}
