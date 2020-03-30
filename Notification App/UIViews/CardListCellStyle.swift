//
//  CardListCellStyle.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 30/03/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit

class CardListStyle {
    static func frontTextWithAnswerIndicator(task: TaskSaved, padding: CGFloat) -> UIStackView {
        let frontTextLabel = UILabel()
        frontTextLabel.formatCardTitleInTable(task: task)
        let frontTextStack = UIStackView(arrangedSubviews: [frontTextLabel])
        if let answer = task.answer, answer.hasContent() {
            let answerIndicator = UIImageView.answerIndicator(usesAutolayout: true)
            frontTextStack.addArrangedSubview(answerIndicator)
            answerIndicator.heightAnchor.constraint(greaterThanOrEqualToConstant: 15.0).isActive = true
            answerIndicator.heightAnchor.constraint(lessThanOrEqualToConstant: 20.0).isActive = true
            answerIndicator.widthAnchor.constraint(equalTo: answerIndicator.heightAnchor, multiplier: 1.1).isActive = true
            frontTextStack.spacing = padding
        }
        return frontTextStack
    }
    
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
}
