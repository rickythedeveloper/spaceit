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

enum PageType {
    case topWithDeleteOption, topWithoutDeleteOption, nonTop
}
