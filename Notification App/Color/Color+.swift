//
//  Color+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

extension Color {
    static func random() -> Color {
        let colour = Color(red: Double.randomForColour(), green: Double.randomForColour(), blue: Double.randomForColour())
        return colour
    }
}

extension Double {
    static func randomForColour() -> Double {
        return Double.random(in: 0.3...0.7)
    }
}
