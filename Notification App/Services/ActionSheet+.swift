//
//  ActionSheet+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 01/10/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import Foundation
import SwiftUI

extension ActionSheet {
    
    static func pageAction(title: String, editName: @escaping ()->Void, addHigherPage: @escaping ()->Void = {}, deleteTopPage: @escaping ()->Void = {}, pageType: PageType) -> ActionSheet {
        if pageType == .nonTop {
            return ActionSheet(title: Text(title), message: nil, buttons: [.cancel(), .default(Text("Edit page name"), action: editName)])
        } else if pageType == .topWithoutDeleteOption {
            return ActionSheet(title: Text(title), message: nil, buttons: [.cancel(), .default(Text("Edit page name"), action: editName), .default(Text("Add a higher level page"), action: addHigherPage)])
        } else if pageType == .topWithDeleteOption {
            return ActionSheet(title: Text(title), message: nil, buttons: [.cancel(), .default(Text("Edit page name"), action: editName), .default(Text("Delete top page"), action: deleteTopPage), .default(Text("Add a higher level page"), action: addHigherPage)])
        } else {
            return ActionSheet(title: Text(title))
        }
    }
    
}


/// A `Popover` on iPad and an `ActionSheet` on iPhone.
public struct PopSheet {
    let title: Text
    let message: Text?
    let buttons: [PopSheet.Button]

    /// Creates an action sheet with the provided buttons.
    public init(title: Text, message: Text? = nil, buttons: [PopSheet.Button] = [.cancel()]) {
        self.title = title
        self.message = message
        self.buttons = buttons
    }

    /// Creates an `ActionSheet` for use on an iPhone device
    func actionSheet() -> ActionSheet {
        ActionSheet(title: title, message: message, buttons: buttons.map({ popButton in
            // convert from PopSheet.Button to ActionSheet.Button (i.e., Alert.Button)
            switch popButton.kind {
            case .default: return .default(popButton.label, action: popButton.action)
            case .cancel: return .cancel(popButton.label, action: popButton.action)
            case .destructive: return .destructive(popButton.label, action: popButton.action)
            }
        }))
    }

    /// Creates a `.popover` for use on an iPad device
    func popover(isPresented: Binding<Bool>) -> some View {
        VStack {
            Divider()
            ForEach(Array(buttons.enumerated()), id: \.offset) { (offset, button) in
                Group {
                    SwiftUI.Button(action: {
                        // hide the popover whenever an action is performed
                        isPresented.wrappedValue = false
                        // another bug: if the action shows a sheet or popover, it will fail unless this one has already been dismissed
                        DispatchQueue.main.async {
                            button.action?()
                        }
                    }, label: {
                        button.label.font(.title)
                    })
                    Divider()
                }
            }
        }
    }
    
    static func pageAction(title: String, editName: @escaping ()->Void, addHigherPage: @escaping ()->Void = {}, deleteTopPage: @escaping ()->Void = {}, pageType: PageType) -> PopSheet {
        if pageType == .nonTop {
            return PopSheet(title: Text(title), message: nil, buttons: [.default(Text("Edit page name"), action: editName), .cancel()])
        } else if pageType == .topWithoutDeleteOption {
            return PopSheet(title: Text(title), message: nil, buttons: [.default(Text("Edit page name"), action: editName), .default(Text("Add a higher level page"), action: addHigherPage), .cancel()])
        } else if pageType == .topWithDeleteOption {
            return PopSheet(title: Text(title), message: nil, buttons: [.default(Text("Edit page name"), action: editName),  .default(Text("Add a higher level page"), action: addHigherPage), .default(Text("Delete top page"), action: deleteTopPage), .cancel()])
        } else {
            return PopSheet(title: Text(title))
        }
    }

    /// A button representing an operation of an action sheet or popover presentation.
    ///
    /// Basically duplicates `ActionSheet.Button` (i.e., `Alert.Button`).
    public struct Button {
        let kind: Kind
        let label: Text
        let action: (() -> Void)?
        enum Kind { case `default`, cancel, destructive }

        /// Creates a `Button` with the default style.
        public static func `default`(_ label: Text, action: (() -> Void)? = {}) -> Self {
            Self(kind: .default, label: label, action: action)
        }

        /// Creates a `Button` that indicates cancellation of some operation.
        public static func cancel(_ label: Text, action: (() -> Void)? = {}) -> Self {
            Self(kind: .cancel, label: label, action: action)
        }

        /// Creates an `Alert.Button` that indicates cancellation of some operation.
        public static func cancel(_ action: (() -> Void)? = {}) -> Self {
            Self(kind: .cancel, label: Text("Cancel"), action: action)
        }

        /// Creates an `Alert.Button` with a style indicating destruction of some data.
        public static func destructive(_ label: Text, action: (() -> Void)? = {}) -> Self {
            Self(kind: .destructive, label: label, action: action)
        }
    }
}

enum PageType {
    case topWithDeleteOption, topWithoutDeleteOption, nonTop
}
