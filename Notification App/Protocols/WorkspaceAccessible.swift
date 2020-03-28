//
//  WorkspaceAccessible.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 28/03/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

protocol WorkspaceAccessible {
    var chosenPage: Page? {get set}
    var pageButton: UIButton {get}
}
