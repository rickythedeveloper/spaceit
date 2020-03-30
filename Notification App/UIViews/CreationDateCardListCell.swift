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
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, task: TaskSaved, isFirst: Bool) {
        self.isFirst = isFirst
        self.task = task
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
    
    private func viewSetup() {
        let padding: CGFloat = 5.0
        self.backgroundColor = .clear

        let vstack = CardListStyle.basicElements(task: self.task, padding: padding, usesAutolayout: true)
        self.contentView.addSubview(vstack)
        
        let creationDateLabel = CardListStyle.creationDateStack(task: self.task, isFirst: isFirst, usesAutolayout: true)
        self.contentView.addSubview(creationDateLabel)
        
        let labelWidth = creationDateLabel.intrinsicContentSize.width
        creationDateLabel.constrainToTrailingSafeAreaOf(self.contentView, padding: padding)
        creationDateLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        creationDateLabel.alignToCenterYOf(self.contentView)
        
        vstack.constrainToLeadingSafeAreaOf(self.contentView, padding: padding)
        vstack.trailingAnchor.constraint(equalTo: creationDateLabel.leadingAnchor, constant: -padding).isActive = true
        vstack.alignToCenterYOf(self.contentView)
        
        self.contentView.heightAnchor.constraint(greaterThanOrEqualTo: vstack.heightAnchor, constant: padding*3.0).isActive = true
        self.contentView.heightAnchor.constraint(greaterThanOrEqualTo: creationDateLabel.heightAnchor, constant: padding*3.0).isActive = true
        self.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0).isActive = true
    }
}
