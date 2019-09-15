//
//  MultiLineTextField.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 15/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import Foundation
import SwiftUI

struct MultiLineTF: UIViewRepresentable {
    @Binding var text: String
    
    var fontSize: CGFloat
    var index: Int
    @ObservedObject var kGuardian: KeyboardGuardian

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {

        let myTextView = UITextView()
        myTextView.delegate = context.coordinator

        myTextView.font = .systemFont(ofSize: self.fontSize)
        myTextView.isScrollEnabled = true
        myTextView.isEditable = true
        myTextView.isUserInteractionEnabled = true
        myTextView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        myTextView.layer.cornerRadius = 10.0

        return myTextView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    class Coordinator : NSObject, UITextViewDelegate {

        var parent: MultiLineTF

        init(_ uiTextView: MultiLineTF) {
            self.parent = uiTextView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            self.parent.kGuardian.showField = self.parent.index
        }
    }
}
