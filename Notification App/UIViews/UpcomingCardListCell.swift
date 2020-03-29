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
    
    private var frontTextLabel = UILabel()
    private var pageBreadcrumbLabel: UILabel?
    private var dueLabel = UILabel()
    private var intervalLabel = UILabel()
    
    private var mainInfoVStack = UIStackView()
    private var subInfoVStack = UIStackView()
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, task: TaskSaved, isFirst: Bool) {
        self.isFirst = isFirst
        self.task = task
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        viewSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        // setting of front text and page breadcrumb
        frontTextLabel.formatCardTitleInTable(task: self.task)
        
        if let breadcrumb = task.page?.breadCrumb() {
            pageBreadcrumbLabel = UILabel()
            pageBreadcrumbLabel?.formatBreadcrumbInTable(task: self.task, breadcrumb: breadcrumb)
        }
        
        // setting of due date and interval
        let descriptionAttirbutes = NSAttributedString.descriptionAttributes(task: self.task)
        let bodyAttributes = NSAttributedString.bodyAttributes(task: self.task)
        let dueDateText = NSMutableAttributedString()
        if isFirst {
            dueDateText.append(NSAttributedString(string: "Due: ", attributes: descriptionAttirbutes))
        }
        dueDateText.append(NSAttributedString(string: task.dueDate().dateString(), attributes: bodyAttributes))
        dueLabel.attributedText = dueDateText
        
        let intervalText = NSMutableAttributedString()
        if isFirst {
            intervalText.append(NSAttributedString(string: "Interval: ", attributes: descriptionAttirbutes))
        }
        intervalText.append(NSAttributedString(string: task.waitTimeString(), attributes: bodyAttributes))
        intervalLabel.attributedText = intervalText
    }
    
    private func viewSetup() {
        let padding: CGFloat = 5.0
        let minRowHeight: CGFloat = 50.0
        
        self.backgroundColor = .clear
        
        mainInfoVStack = UIStackView(arrangedSubviews: [frontTextLabel])
        if let label = pageBreadcrumbLabel {
            mainInfoVStack.addArrangedSubview(label)
        }
        mainInfoVStack.axis = .vertical
        mainInfoVStack.distribution = .equalSpacing
        mainInfoVStack.spacing = padding
        mainInfoVStack.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(mainInfoVStack)
        
        subInfoVStack = UIStackView(arrangedSubviews: [dueLabel, intervalLabel])
        subInfoVStack.axis = .vertical
        subInfoVStack.distribution = .equalSpacing
        subInfoVStack.spacing = padding
        subInfoVStack.alignment = .trailing
        subInfoVStack.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(subInfoVStack)
        
        let minSubInfoWidth = max(dueLabel.intrinsicContentSize.width, intervalLabel.intrinsicContentSize.width)
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
