//
//  CardListCell.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 27/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

enum CardListCellType: Int {
    case upcoming = 0, alphabetical, creationDate
}

class CardListCell: UITableViewCell {
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String, task: TaskSaved, isFirst: Bool, cellType: CardListCellType) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        switch cellType {
        case .upcoming:
            self.addSubview(UpcomingCardListCell(frame: frame, task: task, isFirst: isFirst))
        case .alphabetical:
            let label = UILabel()
            label.text = "test"
            label.frame = self.frame
            self.addSubview(label)
        case .creationDate:
            let label = UILabel()
            label.text = "test"
            label.frame = self.frame
            self.addSubview(label)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

class UpcomingCardListCell: UIView {
    private var isFirst: Bool
    
    private var task: TaskSaved
    
    private var frontTextLabel = UILabel()
    private var pageBreadcrumbLabel: UILabel?
    private var dueLabel = UILabel()
    private var intervalLabel = UILabel()
    
    init(frame: CGRect, task: TaskSaved, isFirst: Bool) {
        self.isFirst = isFirst
        self.task = task
        
        super.init(frame: frame)
        
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
        
        let dueDateText = NSMutableAttributedString()
        if isFirst {
            let dueAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray, .font: UIFont.preferredFont(forTextStyle: .body)]
            let due = NSAttributedString(string: "Due: ", attributes: dueAttributes)
            dueDateText.append(due)
        }
        let dueDateStringAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .body)]
        let dueDateString = NSAttributedString(string: task.dueDate().dateString(), attributes: dueDateStringAttributes)
        dueDateText.append(dueDateString)
        dueLabel.attributedText = dueDateText
        
        intervalLabel.text = task.waitTimeString()
        intervalLabel.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private func viewSetup() {
        addSubview(frontTextLabel)
        frontTextLabel.translatesAutoresizingMaskIntoConstraints = false
        if let label = pageBreadcrumbLabel {
            addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
        }
        addSubview(dueLabel)
        dueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(intervalLabel)
        intervalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 5.0
        dueLabel.constrainToTopSafeAreaOf(self)
        dueLabel.constrainToTrailingSafeAreaOf(self, padding: padding)
        dueLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: dueLabel.intrinsicContentSize.width).isActive = true
        dueLabel.sizeToFit()
        
        intervalLabel.isBelow(dueLabel, padding: padding)
        intervalLabel.constrainToTrailingSafeAreaOf(self, padding: padding)
        intervalLabel.sizeToFit()
        
        frontTextLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        frontTextLabel.constrainToLeadingSafeAreaOf(self, padding: padding)
        frontTextLabel.trailingAnchor.constraint(equalTo: dueLabel.leadingAnchor, constant: -padding).isActive = true
        frontTextLabel.sizeToFit()
        
        if let label = pageBreadcrumbLabel {
            label.isBelow(frontTextLabel, padding: padding)
            label.leadingAnchor.constraint(equalTo: frontTextLabel.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: frontTextLabel.trailingAnchor).isActive = true
            label.sizeToFit()
        }
    }
}
