//
//  CardListCellStyle.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 30/03/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

class CardListStyle {
    static func basicElements(task: TaskSaved, padding: CGFloat, usesAutolayout: Bool) -> UIStackView {
        let frontTextLabel = UILabel()
        frontTextLabel.formatCardTitleInTable(task: task)
        let mainStack = UIStackView(arrangedSubviews: [frontTextLabel])
        
        if task.page != nil {
            let breadcrumbLabel = UILabel()
            breadcrumbLabel.formatBreadcrumbInTable(task: task)
            mainStack.addArrangedSubview(breadcrumbLabel)
        }
        
        mainStack.axis = .vertical
        mainStack.distribution = .equalSpacing
        mainStack.spacing = padding
        mainStack.translatesAutoresizingMaskIntoConstraints = !usesAutolayout
        
        if let answer = task.answer, answer.hasContent() {
            let answerIndicator = UIImageView.answerIndicator(usesAutolayout: true)
            answerIndicator.heightAnchor.constraint(greaterThanOrEqualToConstant: 15.0).isActive = true
            answerIndicator.heightAnchor.constraint(lessThanOrEqualToConstant: 20.0).isActive = true
            answerIndicator.widthAnchor.constraint(equalTo: answerIndicator.heightAnchor, multiplier: 1.1).isActive = true
            if !task.isActive {answerIndicator.tintColor = UIColor.archivedGray().body}
            
            let indicatorContainer = UIView()
            indicatorContainer.addSubview(answerIndicator)
            indicatorContainer.translatesAutoresizingMaskIntoConstraints = false
            indicatorContainer.widthAnchor.constraint(equalTo: answerIndicator.widthAnchor).isActive = true
            answerIndicator.alignToCenterXOf(indicatorContainer)
            answerIndicator.alignToCenterYOf(indicatorContainer)
            let finalStack = UIStackView(arrangedSubviews: [mainStack, indicatorContainer])
            finalStack.spacing = padding
            finalStack.axis = .horizontal
            finalStack.translatesAutoresizingMaskIntoConstraints = !usesAutolayout
            return finalStack
        }
        
        return mainStack
    }
    
    static func dueAndIntervalStack(task: TaskSaved, isFirst: Bool, padding: CGFloat, usesAutolayout: Bool) -> (stack: UIStackView, dueLabelWidth: CGFloat, intervalLabelWidth: CGFloat) {
        let dueLabel = UILabel()
        let intervalLabel = UILabel()
        
        // setting of due date and interval
        let descriptionAttirbutes = NSAttributedString.descriptionAttributes(task: task)
        let bodyAttributes = NSAttributedString.bodyAttributes(task: task)
        
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
        
        let stack = UIStackView(arrangedSubviews: [dueLabel, intervalLabel])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = padding
        stack.alignment = .trailing
        stack.translatesAutoresizingMaskIntoConstraints = !usesAutolayout
        
        return (stack, dueLabel.intrinsicContentSize.width, intervalLabel.intrinsicContentSize.width)
    }
    
    static func creationDateStack(task: TaskSaved, isFirst: Bool, usesAutolayout: Bool) -> UILabel {
        guard let creationDate = task.creationDateString() else {return UILabel()}
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = !usesAutolayout
        let descriptionAttirbutes = NSAttributedString.descriptionAttributes(task: task)
        let bodyAttributes = NSAttributedString.bodyAttributes(task: task)
        let creationDateText = NSMutableAttributedString()
        if isFirst {
            creationDateText.append(NSAttributedString(string: "Created on ", attributes: descriptionAttirbutes))
        }
        creationDateText.append(NSAttributedString(string: creationDate, attributes: bodyAttributes))
        label.attributedText = creationDateText
        return label
    }
}
