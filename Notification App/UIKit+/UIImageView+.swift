//
//  UIImageView+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 30/03/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension UIImageView {
    static func answerIndicator(usesAutolayout: Bool) -> UIImageView {
        let image = UIImage(systemName: "doc.text")
        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = !usesAutolayout
        iv.contentMode = .scaleAspectFit
        return iv
    }
}
