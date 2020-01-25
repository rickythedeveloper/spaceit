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
        return (UIColor.systemGray3).withAlphaComponent(0.5)
    }
    
    static func pageButtonBackground() -> UIColor {
        return (UIColor.systemGray).withAlphaComponent(0.2)
    }
}
