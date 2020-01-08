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
}
