//
//  AlphabeticalCardListCell.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 29/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

class AlphabeticalCardListCell: UITableViewCell {
    private var task: TaskSaved
    
    private var frontTextLabel = UILabel()
    private var pageBreadcrumbLabel: UILabel?
    
    private var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, task: TaskSaved) {
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
        frontTextLabel.text = task.question
        frontTextLabel.lineBreakMode = .byWordWrapping
        frontTextLabel.numberOfLines = 0
        
        if let breadcrumb = task.page?.breadCrumb() {
            pageBreadcrumbLabel = UILabel()
            pageBreadcrumbLabel!.text = breadcrumb
        }
        
        
        if !self.task.isActive {
            frontTextLabel.textColor = (UIColor.systemGray).withAlphaComponent(0.5)
            pageBreadcrumbLabel?.textColor = (UIColor.systemGray).withAlphaComponent(0.5)
        } else if self.task.isDue() {
            frontTextLabel.textColor = .systemRed
            pageBreadcrumbLabel?.textColor = .systemRed
        }
    }
    
    private func viewSetup() {
        let padding: CGFloat = 5
        let minRowHeight: CGFloat = 50.0
        stack.addArrangedSubview(frontTextLabel)
        if let label = pageBreadcrumbLabel {
            stack.addArrangedSubview(label)
        }
        
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = padding
        self.contentView.addSubview(stack)
        
        stack.alignToCenterYOf(self.contentView)
        stack.constrainToSideSafeAreasOf(self.contentView, padding: padding)
        
        self.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: minRowHeight).isActive = true
    }

}
