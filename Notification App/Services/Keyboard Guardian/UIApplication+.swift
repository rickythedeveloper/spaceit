//
//  UIApplication+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 12/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
