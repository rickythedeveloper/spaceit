//
//  UIFont+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 09/03/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func cardTitleInTable() -> UIFont {
        return .preferredFont(forTextStyle: .body)
    }
    static func breadCrumbInTable() -> UIFont {
        return .preferredFont(forTextStyle: .caption1)
    }
}
