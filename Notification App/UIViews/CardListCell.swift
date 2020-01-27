//
//  CardListCell.swift
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
        frontTextLabel.text = task.question
        frontTextLabel.lineBreakMode = .byWordWrapping
        frontTextLabel.numberOfLines = 0
        
        if let breadcrumb = task.page?.breadCrumb() {
            pageBreadcrumbLabel = UILabel()
            pageBreadcrumbLabel!.text = breadcrumb
        }
        
        var descriptionAttirbutes: [NSAttributedString.Key: Any]
        var bodyAttributes: [NSAttributedString.Key: Any]
        if self.task.isDue() {
            frontTextLabel.textColor = .systemRed
            pageBreadcrumbLabel?.textColor = .systemRed
            descriptionAttirbutes = [.foregroundColor: (UIColor.systemRed).withAlphaComponent(0.6), .font: UIFont.preferredFont(forTextStyle: .body)]
            bodyAttributes = [.foregroundColor: UIColor.systemRed, .font: UIFont.preferredFont(forTextStyle: .body)]
        } else {
            descriptionAttirbutes = [.foregroundColor: UIColor.systemGray, .font: UIFont.preferredFont(forTextStyle: .body)]
            bodyAttributes = [.font: UIFont.preferredFont(forTextStyle: .body)]
        }
        
        
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
        subInfoVStack.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        
        mainInfoVStack.trailingAnchor.constraint(equalTo: subInfoVStack.leadingAnchor, constant: -padding).isActive = true
        mainInfoVStack.constrainToLeadingSafeAreaOf(self.contentView, padding: padding)
        mainInfoVStack.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        
        self.contentView.heightAnchor.constraint(greaterThanOrEqualTo: mainInfoVStack.heightAnchor, constant: padding*2.0).isActive = true
        self.contentView.heightAnchor.constraint(greaterThanOrEqualTo: subInfoVStack.heightAnchor, constant: padding*2.0).isActive = true
    }
}
