//
//  CreationDateCardListCell.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 30/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

class CreationDateCardListCell: UITableViewCell {
    
    private var isFirst: Bool
    
    private var task: TaskSaved
    
    private var frontTextLabel = UILabel()
    private var pageBreadcrumbLabel: UILabel?
    private var creationDateLabel: UILabel?
    
    private var vstack = UIStackView()
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setup() {
        // setting of front text and page breadcrumb
        frontTextLabel.text = task.question
        frontTextLabel.lineBreakMode = .byWordWrapping
        frontTextLabel.numberOfLines = 0
        frontTextLabel.font = .cardTitleInTable()
        
        if let breadcrumb = task.page?.breadCrumb() {
            pageBreadcrumbLabel = UILabel()
            pageBreadcrumbLabel!.text = breadcrumb
            pageBreadcrumbLabel!.font = .breadCrumbInTable()
        }
        
        if !self.task.isActive {
            frontTextLabel.textColor = UIColor.archivedGray().body
            pageBreadcrumbLabel?.textColor = UIColor.archivedGray().body
        } else if self.task.isDue() {
            frontTextLabel.textColor = UIColor.dueRed().body
            pageBreadcrumbLabel?.textColor = UIColor.dueRed().body
        }
        
        // setting the creation date label
        guard let creationDate = task.creationDateString() else {return}
        
        creationDateLabel = UILabel()
        let descriptionAttirbutes = NSAttributedString.descriptionAttributes(task: self.task)
        let bodyAttributes = NSAttributedString.bodyAttributes(task: self.task)
        let creationDateText = NSMutableAttributedString()
        if isFirst {
            creationDateText.append(NSAttributedString(string: "Created on ", attributes: descriptionAttirbutes))
        }
        creationDateText.append(NSAttributedString(string: creationDate, attributes: bodyAttributes))
        creationDateLabel!.attributedText = creationDateText
    }
    
    private func viewSetup() {
        let padding: CGFloat = 5.0
        let minRowHeight: CGFloat = 50.0

        vstack.addArrangedSubview(frontTextLabel)
        if let label = pageBreadcrumbLabel {
            vstack.addArrangedSubview(label)
        }
        vstack.axis = .vertical
        vstack.distribution = .equalSpacing
        vstack.spacing = padding
        vstack.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(vstack)
        
        if let label = creationDateLabel {
            let labelWidth = label.intrinsicContentSize.width
            label.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(label)
            label.constrainToTrailingSafeAreaOf(self.contentView, padding: padding)
            label.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
            label.alignToCenterYOf(self.contentView)
            
            vstack.constrainToLeadingSafeAreaOf(self.contentView, padding: padding)
            vstack.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -padding).isActive = true
            vstack.alignToCenterYOf(self.contentView)
        } else {
            vstack.constrainToTopSafeAreaOf(self.contentView, padding: padding)
            vstack.constrainToSideSafeAreasOf(self.contentView, padding: padding)
            vstack.constrainToBottomSafeAreaOf(self.contentView, padding: padding)
        }
        
        self.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: minRowHeight).isActive = true
    }

}
