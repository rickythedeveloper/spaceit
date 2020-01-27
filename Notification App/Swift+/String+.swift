//
//  String+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 17/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import Foundation

extension String {
    func hasContent() -> Bool {
        var hasContent = false
        for character in self {
            if !(character == " " || character == "\n" || character == "\t") {
                hasContent = true
                break
            }
        }
        return hasContent
    }
}
