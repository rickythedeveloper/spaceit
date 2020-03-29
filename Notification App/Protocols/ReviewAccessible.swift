//
//  ReviewAccessible.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 29/03/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import Foundation

protocol ReviewAccessible {
    func happyAction()
    func okayAction()
    func sadAction()
    func depressedAction()
    func cancelAction()
}
