//
//  NewPageTableViewCell.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 05/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import RickyFramework

class NewPageTextField: UITextField {
    var containerView: FinderStyleContainerView?
}

class NewPageTableViewCell: UITableViewCell {
    var textField = NewPageTextField()
    
    init(reuseIdentifier: String?, TFdelegate: UITextFieldDelegate, containerView: FinderStyleContainerView) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setInfo(TFdelegate: TFdelegate, containerView: containerView)
        cleanCell()
        textFieldSetup()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//    }
}

extension NewPageTableViewCell {
    private func setInfo(TFdelegate: UITextFieldDelegate, containerView: FinderStyleContainerView) {
        textField.delegate = TFdelegate
        textField.containerView = containerView
    }
    
    private func textFieldSetup() {
        let padding: CGFloat = 10
        textField.backgroundColor = .tvBackground()
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 1))
        textField.leftView = leftPadding
        textField.leftViewMode = .always
        let rightPadding = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 1))
        textField.rightView = rightPadding
        textField.rightViewMode = .always
        textField.layer.cornerRadius = padding
        textField.layer.masksToBounds = true
        textField.textAlignment = .center
        textField.placeholder = "New page"
    }
    
    private func addConstraints() {
        self.contentView.addSubview(textField)
        textField.fitToSafeAreaOf(self.contentView, padding: 10)
    }
}
