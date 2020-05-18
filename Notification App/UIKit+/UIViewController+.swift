//
//  UIViewController+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 17/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension UIViewController {
    func setBackgroundLogo(maxSizeMultiplier: CGFloat) {
        let image = UIImage.logo()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: maxSizeMultiplier),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: maxSizeMultiplier),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
