//
//  UIButton+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 06/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

extension UIButton {
    static func actionButton(text: String = "", action: Selector, font: UIFont? = nil, backgroundColor: UIColor? = nil, backgroundAlpha: CGFloat? = nil, usesAutoLayout: Bool) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = font
        button.setTitleColor(.myTextColor(), for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.sizeToFit()
        if let alpha = backgroundAlpha {
            button.backgroundColor = backgroundColor?.withAlphaComponent(alpha)
        } else {
            button.backgroundColor = backgroundColor
        }
        button.translatesAutoresizingMaskIntoConstraints = !usesAutoLayout
        button.sizeToFit()
        button.addTarget(nil, action: action, for: .touchUpInside)
        button.layer.cornerRadius = button.layer.frame.height / 4.0
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }
    
    static func pageButton(text: String, action: Selector, usesAutoLayout: Bool) -> UIButton {
        let button = UIButton.actionButton(text: text, action: action, font: UIFont.preferredFont(forTextStyle: .callout), backgroundColor: UIColor.pageButtonBackground(), usesAutoLayout: usesAutoLayout)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        return button
    }
    
    func layoutPageSelectButton(parentView: UIView, padding: CGFloat) {
        if self.titleLabel != nil {
            self.heightAnchor.constraint(equalTo: self.titleLabel!.heightAnchor, constant: padding).isActive = true
        }
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parentView.topAnchor, constant: padding*3),
            self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            self.widthAnchor.constraint(lessThanOrEqualTo: parentView.widthAnchor, constant: -padding*2.0)
        ])
    }
    
    static func reviewButton(task: TaskSaved, ease: Int, cardEditVC: CardEditVC, action: Selector, usesAutolayout: Bool) -> UIButton {
        let nextWaitTime = String.time(timeInterval: task.nextWaitTime(ease: ease))
        var bgColor: UIColor
        var description: String
        switch ease {
        case 1:
            bgColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1)
            description = "Very hard"
            break
        case 2:
            bgColor = UIColor(red: 1, green: 102/255, blue: 0, alpha: 1)
            description = "Hard"
            break
        case 3:
            let brightness: CGFloat = 0.9
            bgColor = UIColor(red: 1*brightness, green: 208/255*brightness, blue: 0, alpha: 1)
            description = "Okay"
            break
        case 4:
            let brightness: CGFloat = 0.9
            bgColor = UIColor(red: 34/255*brightness, green: 1*brightness, blue: 0, alpha: 1)
            description = "Easy"
            break
        default:
            fatalError("ease is not in the right range")
        }
        
        let descLabel = UILabel()
        descLabel.text = description
        descLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descLabel.textAlignment = .center
        descLabel.adjustsFontSizeToFitWidth = true
        
        let waitLabel = UILabel()
        waitLabel.text = nextWaitTime
        waitLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        waitLabel.textAlignment = .center
        waitLabel.adjustsFontSizeToFitWidth = true
        
        let stack = UIStackView(arrangedSubviews: [descLabel, waitLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5.0
        stack.isUserInteractionEnabled = false
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = !usesAutolayout
        button.backgroundColor = bgColor
        button.layer.cornerRadius = 10.0
        button.addSubview(stack)
        button.addTarget(nil, action: action, for: .touchUpInside)
        
        
        NSLayoutConstraint.activate(stack.constraintsToAlignCenter(with: button))
        NSLayoutConstraint.activate([
            stack.heightAnchor.constraint(lessThanOrEqualTo: button.heightAnchor, multiplier: 0.9),
            stack.widthAnchor.constraint(lessThanOrEqualTo: button.widthAnchor, multiplier: 0.9)
        ])
        
        return button
    }
}
