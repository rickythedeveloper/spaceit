//
//  UpcomingCardListCell.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 27/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

class UpcomingCardListCell: UITableViewCell {
    var isFirst: Bool? {
        didSet {
            viewSetup()
        }
    }
    var task: TaskSaved? {
        didSet {
            viewSetup()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, task: TaskSaved, isFirst: Bool) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        self.isFirst = isFirst
        self.task = task
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewSetup() {
        guard let task = task, let isFirst = isFirst else {return}
        self.cleanCell()
        
        let padding: CGFloat = 5.0
        let minRowHeight: CGFloat = 50.0
        
        self.backgroundColor = .clear
        
        let mainInfoVStack = CardListStyle.basicElements(task: task, padding: padding, usesAutolayout: true)
        self.contentView.addSubview(mainInfoVStack)
        
        let (subInfoVStack, duelabelWidth, intervalLabelWidth) = CardListStyle.dueAndIntervalStack(task: task, isFirst: isFirst, padding: padding, usesAutolayout: true)
        self.contentView.addSubview(subInfoVStack)
        
        let minSubInfoWidth = max(duelabelWidth, intervalLabelWidth)
        subInfoVStack.constrainToTrailingSafeAreaOf(self.contentView, padding: padding)
        subInfoVStack.widthAnchor.constraint(equalToConstant: minSubInfoWidth).isActive = true
        subInfoVStack.alignToCenterYOf(self.contentView)
        
        mainInfoVStack.trailingAnchor.constraint(equalTo: subInfoVStack.leadingAnchor, constant: -padding).isActive = true
        mainInfoVStack.constrainToLeadingSafeAreaOf(self.contentView, padding: padding)
        mainInfoVStack.alignToCenterYOf(self.contentView)
        
        self.contentView.heightAnchor.constraint(greaterThanOrEqualTo: mainInfoVStack.heightAnchor, constant: padding*3.0).isActive = true
        self.contentView.heightAnchor.constraint(greaterThanOrEqualTo: subInfoVStack.heightAnchor, constant: padding*3.0).isActive = true
        self.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: minRowHeight).isActive = true
    }
}
