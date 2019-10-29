//
//  View+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 29/10/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI
import UIKit

public extension View {
    /// Creates an `ActionSheet` on an iPhone or the equivalent `popover` on an iPad, in order to work around `.actionSheet` crashing on iPad (`FB7397761`).
    ///
    /// - Parameters:
    ///     - isPresented: A `Binding` to whether the action sheet should be shown.
    ///     - content: A closure returning the `PopSheet` to present.
    func popSheet(isPresented: Binding<Bool>, arrowEdge: Edge = .bottom, content: @escaping () -> PopSheet) -> some View {
        Group {
            if self.determineLayout() == .iPhoneFullScreen || self.determineLayout() == .iPadOneThirdScreen || (self.determineLayout() == .iPadTwoThirdScreen && UIDevice.current.orientation.isPortrait) {
                actionSheet(isPresented: isPresented, content: { content().actionSheet() })
            } else {
                popover(isPresented: isPresented, attachmentAnchor: .rect(.bounds), arrowEdge: arrowEdge, content: { content().popover(isPresented: isPresented) })

            }
        }
    }
    
    private func getScreenSize () -> (description:String, size:CGRect) {
        let size = UIScreen.main.bounds
        let str = "SCREEN SIZE:\nwidth: \(size.width)\nheight: \(size.height)"
        return (str, size)
    }

    private func getApplicationSize () -> (description:String, size:CGRect) {
        let size = UIApplication.shared.windows[0].bounds
        let str = "\n\nAPPLICATION SIZE:\nwidth: \(size.width)\nheight: \(size.height)"
        return (str, size)
    }

    private func determineLayout () -> LayoutStyle {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .iPhoneFullScreen
        }
        let screenSize = getScreenSize().size
        let appSize = getApplicationSize().size
        let screenWidth = screenSize.width
        let appWidth = appSize.width
        if screenSize == appSize {
            return .iPadFullscreen
        }

        // Set a range in case there is some mathematical inconsistency or other outside influence that results in the application width being less than exactly 1/3, 1/2 or 2/3.
        let lowRange = screenWidth - 15
        let highRange = screenWidth + 15

        if lowRange / 2 <= appWidth && appWidth <= highRange / 2 {
            return .iPadHalfScreen
        } else if appWidth <= highRange * 0.40 {
            return .iPadOneThirdScreen
        } else {
            return .iPadTwoThirdScreen
        }
    }
}

enum LayoutStyle: String {
    case iPadFullscreen         = "iPad Full Screen"
    case iPadHalfScreen         = "iPad 1/2 Screen"
    case iPadTwoThirdScreen    = "iPad 2/3 Screen"
    case iPadOneThirdScreen     = "iPad 1/3 Screen"
    case iPhoneFullScreen       = "iPhone"
}
