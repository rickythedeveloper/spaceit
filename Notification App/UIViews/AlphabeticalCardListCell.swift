//
//  AlphabeticalCardListCell.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 29/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

class AlphabeticalCardListCell: UITableViewCell {
    var task: TaskSaved? {
        didSet {
            viewSetup()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, task: TaskSaved) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.task = task
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
        guard let task = task else {return}
        self.cleanCell()
        
        let padding: CGFloat = 5
        self.backgroundColor = .clear
        
        let stack = CardListStyle.basicElements(task: task, padding: padding, usesAutolayout: true)
        self.contentView.addSubview(stack)

        NSLayoutConstraint.activate([stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)])
        NSLayoutConstraint.activate(stack.constraintsToFitSides(within: contentView.safeAreaLayoutGuide, padding: padding))

        self.contentView.heightAnchor.constraint(greaterThanOrEqualTo: stack.heightAnchor, constant: padding*3.0).isActive = true
        self.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0).isActive = true
    }

}
