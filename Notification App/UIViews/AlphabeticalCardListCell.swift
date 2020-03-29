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
        frontTextLabel.formatCardTitleInTable(task: self.task)
        
        if let breadcrumb = task.page?.breadCrumb() {
            pageBreadcrumbLabel = UILabel()
            pageBreadcrumbLabel?.formatBreadcrumbInTable(task: self.task, breadcrumb: breadcrumb)
        }
    }
    
    private func viewSetup() {
        let padding: CGFloat = 5
        self.backgroundColor = .clear

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
        
        self.contentView.heightAnchor.constraint(equalTo: stack.heightAnchor, constant: padding*3.0).isActive = true
    }

}
