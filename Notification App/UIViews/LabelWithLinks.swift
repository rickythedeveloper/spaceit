//
//  LabelWithLinks.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 05/04/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

class LabelWithLinks: UILabel {
    
    var rangesForLinks = [NSRange]()
    var links = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(text: String, rangesForLinks: [NSRange], links: [String], textColor: UIColor, font: UIFont, usesAutolayout: Bool) {
        self.init(frame: .zero)
        guard rangesForLinks.count == links.count else {fatalError("Number of links and number of ranges dont match")}
        setup(text: text, rangesForLinks: rangesForLinks, links: links, textColor: textColor, font: font, usesAutolayout: usesAutolayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LabelWithLinks {
    private func setup(text: String, rangesForLinks: [NSRange], links: [String], textColor: UIColor, font: UIFont, usesAutolayout: Bool) {
        self.rangesForLinks = rangesForLinks
        self.links = links

        let attributedText = NSMutableAttributedString(string: text)
        for n in 0..<rangesForLinks.count {
            attributedText.addAttribute(.link, value: links[n], range: rangesForLinks[n])
        }

        self.attributedText = attributedText
        translatesAutoresizingMaskIntoConstraints = !usesAutolayout
        numberOfLines = 0
        self.textColor = textColor
        self.font = font
        textAlignment = .center
        isUserInteractionEnabled = true

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:))))
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        for n in 0..<rangesForLinks.count {
            if gesture.didTapAttributedTextInLabel(label: self, inRange: rangesForLinks[n]) {
                if let url = URL(string: links[n]) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}
