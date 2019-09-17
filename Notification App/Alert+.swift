//
//  Alert+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 17/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

extension Alert {
    static func invalidQuestion() -> Alert {
        return Alert(title: Text("Invalid question"), message: Text("Please enter the question"), dismissButton: .default(Text("OK")))
    }
}
