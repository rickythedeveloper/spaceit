//
//  Array+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import Foundation

extension Array {
    mutating func moveItem(fromIndex: Int, toIndex: Int) {
        let element = self.remove(at: fromIndex)
        self.insert(element, at: toIndex)
    }
    
    mutating func moveItemToLast(fromIndex: Int) {
        moveItem(fromIndex: fromIndex, toIndex: self.count-1)
    }
}
