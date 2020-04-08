//
//  UITableView+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 08/04/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension UITableView {
    func firstVisibleRow() -> Int {
        var lowest: Int?
        if let indexPaths = self.indexPathsForVisibleRows {
            for indexPath in indexPaths {
                if let _lowest = lowest {
                    if indexPath.row < _lowest {
                        lowest = indexPath.row
                    }
                } else {
                    lowest = indexPath.row
                }
            }
        }
        return lowest ?? 0
    }
    
    func shows(indexPath: IndexPath) -> Bool {
        if let indexPaths = self.indexPathsForVisibleRows {
            for path in indexPaths {
                if path == indexPath {
                    return true
                }
            }
        }
        return false
    }
}
