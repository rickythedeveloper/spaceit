//
//  SubscribeButton.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 05/04/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

class SubscribeFrame: UIView {
    
    var priceTag = UILabel()
    var startButton = UIButton()
    var descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(price: String? = nil, startButtonText: String? = nil, description: String? = nil, action: Selector? = nil) {
        self.init(frame: .zero)
        setup(price: price, startButtonText: startButtonText, description: description, action: action)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SubscribeFrame {
    func setInfo(price: String?, startButtonText: String?, description: String?, action: Selector?) {
        if let price = price {
            priceTag.text = price
        }
        if let startButtonText = startButtonText {
            startButton.setTitle(startButtonText, for: .normal)
        }
        if let description = description {
            descriptionLabel.text = description
        }
        if let action = action {
            startButton.addTarget(nil, action: action, for: .touchUpInside)
        }
    }
}

private extension SubscribeFrame {
    func setup(price: String?, startButtonText: String?, description: String?, action: Selector?) {
        // View itself
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 1.0
        
        addSubview(priceTag)
        addSubview(startButton)
        addSubview(descriptionLabel)
        
        priceTag.text = price
        priceTag.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        priceTag.translatesAutoresizingMaskIntoConstraints = false
        priceTag.textAlignment = .center
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.setTitle(startButtonText, for: .normal)
        startButton.setTitleColor(UIColor.myTextColor(), for: .normal)
        startButton.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        startButton.titleLabel?.adjustsFontSizeToFitWidth = true
        startButton.backgroundColor = UIColor(red: 0.4, green: 0.9, blue: 0.7, alpha: 0.8)
        startButton.layer.cornerRadius = 10.0
        if let action = action {
            startButton.addTarget(nil, action: action, for: .touchUpInside)
        }
        
        descriptionLabel.text = description
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
    }
    
    func addConstraints() {
        let padding: CGFloat = 20.0
        
        priceTag.constrainToTopSafeAreaOf(self, padding: padding)
        priceTag.constrainToSideSafeAreasOf(self, padding: padding)
        priceTag.heightAnchor.constraint(greaterThanOrEqualTo: self.heightAnchor, multiplier: 0.2).isActive = true
        priceTag.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, multiplier: 0.3).isActive = true
        
        startButton.isBelow(priceTag, padding: padding)
        startButton.constrainToSideSafeAreasOf(self, padding: padding)
        startButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        descriptionLabel.isBelow(startButton, padding: padding)
        descriptionLabel.constrainToSideSafeAreasOf(self, padding: padding)
        descriptionLabel.constrainToBottomSafeAreaOf(self, padding: padding)
    }
}
