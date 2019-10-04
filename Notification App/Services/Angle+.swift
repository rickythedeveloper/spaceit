//
//  Angle+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 23/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import Foundation
import SwiftUI

extension Angle {
    static func randomSmallAngle() -> Angle {
        return Angle(degrees: Double.random(in: -2.5...2.5))
    }
}
