//
//  UpcomingCardListCell.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 27/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

class UpcomingCardListCell: UITableViewCell {
    private var isFirst: Bool
    private var task: TaskSaved
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, task: TaskSaved, isFirst: Bool) {
        self.isFirst = isFirst
        self.task = task
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewSetup() {
        let padding: CGFloat = 5.0
        let minRowHeight: CGFloat = 50.0
        
        self.backgroundColor = .clear
        
        let mainInfoVStack = CardListStyle.basicElements(task: self.task, padding: padding, usesAutolayout: true)
        self.contentView.addSubview(mainInfoVStack)
        
        let (subInfoVStack, duelabelWidth, intervalLabelWidth) = CardListStyle.dueAndIntervalStack(task: self.task, contentView: self.contentView, isFirst: isFirst, padding: padding, usesAutolayout: true)
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
