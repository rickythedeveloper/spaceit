//
//  UIVIew+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 04/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension UIView {
    public func constrainToTopSafeAreaOf(_ view: UIView, padding: CGFloat = 0.0) {
//        self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding).isActive = true
    }
    
    public func constrainToBottomSafeAreaOf(_ view: UIView, padding: CGFloat = 0.0) {
        self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: padding).isActive = true
    }
    
    public func constrainToLeadingSafeAreaOf(_ view: UIView, padding: CGFloat = 0.0) {
        self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding).isActive = true
    }
    
    public func constrainToTrailingSafeAreaOf(_ view: UIView, padding: CGFloat = 0.0) {
        self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding).isActive = true
    }
    
    public func constrainToSideSafeAreasOf(_ view: UIView, padding: CGFloat = 0.0) {
        constrainToLeadingSafeAreaOf(view, padding: padding)
        constrainToTrailingSafeAreaOf(view, padding: padding)
    }
    
    public func alignToCenterXOf(_ view: UIView) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    public func isBelow(_ view: UIView, padding: CGFloat = 0.0) {
        self.topAnchor.constraint(equalTo: view.bottomAnchor, constant: padding).isActive = true
    }
    
    public func isBelow(_ anchor: NSLayoutYAxisAnchor, padding: CGFloat = 0.0) {
        self.topAnchor.constraint(equalTo: anchor, constant: padding).isActive = true
    }
}
