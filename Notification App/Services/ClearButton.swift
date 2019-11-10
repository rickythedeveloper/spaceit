//
//  ClearButton.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 10/11/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct ClearButton: ViewModifier {
    @Binding var text: String

    public func body(content: Content) -> some View {
        ZStack {
            content
            
            if text.hasContent() {
                HStack {
                    Spacer()
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.secondary)
                            .padding([.trailing], 5)
                    }
                    
                }
            }
        }
    }
}
