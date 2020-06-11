//
//  UIColor+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 08/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension UIColor {
    public static func myBackGroundColor() -> UIColor {
        return UIColor(named: "myBackgroundColor") ?? UIColor.red
    }
    
    static func myTextColor() -> UIColor {
        return UIColor(named: "myTextColor") ?? UIColor.red
    }
    
    static func tvBackground() -> UIColor {
        return (UIColor.systemGray).withAlphaComponent(0.2)
    }
    
    static func backgroundGray() -> UIColor {
        return UIColor(named: "backgroundGray") ?? UIColor.red
    }
    
    static func pageButtonBackground() -> UIColor {
        return (UIColor.systemGray).withAlphaComponent(0.2)
    }
    
    static func dueRed() -> (body: UIColor, desc: UIColor) {
        return (UIColor.systemRed, (UIColor.systemRed).withAlphaComponent(0.6))
    }
    
    static func archivedGray() -> (body: UIColor, desc: UIColor) {
        return ((UIColor.systemGray).withAlphaComponent(0.5), (UIColor.systemGray).withAlphaComponent(0.4))
    }
    
    static func tableViewSelectionColors() -> (full: UIColor, semi: UIColor) {
        return (UIColor.systemRed.withAlphaComponent(0.23), UIColor.systemRed.withAlphaComponent(0.15))
    }
}
