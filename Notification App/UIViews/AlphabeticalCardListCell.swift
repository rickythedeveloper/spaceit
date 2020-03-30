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
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, task: TaskSaved) {
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
        let padding: CGFloat = 5
        self.backgroundColor = .clear
        
        let stack = CardListStyle.basicElements(task: self.task, padding: padding, usesAutolayout: true)
        self.contentView.addSubview(stack)

        stack.alignToCenterYOf(self.contentView)
        stack.constrainToSideSafeAreasOf(self.contentView, padding: padding)

        self.contentView.heightAnchor.constraint(greaterThanOrEqualTo: stack.heightAnchor, constant: padding*3.0).isActive = true
        self.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0).isActive = true
    }

}
