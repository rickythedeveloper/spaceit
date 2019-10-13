//
//  NewPageTF.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/10/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct NewPageTF: View {
    
    @Binding var newPageName: String
    
    var addPageAction: ()->Void
    
    @ObservedObject var kGuardian: KeyboardGuardian
    
    var body: some View {
        HStack {
            TextField("New Page", text: self.$newPageName, onEditingChanged: {
                if $0 {
                    self.kGuardian.showField = 0
                    
                } else {
                    
                }
            }, onCommit: {
                UIApplication.shared.endEditing()
                if self.newPageName.hasContent() {
                    self.addPageAction()
                }
            })
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10.0)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .background(GeometryGetter(rect: self.$kGuardian.rects[0]))
            
//            Button(action: self.addPageAction) {
//                Image(systemName: "plus")
//            }
//                .disabled(!self.newPageName.hasContent())
        }
            .font(.title)
//            .padding()
    }
}

//struct NewPageTF_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPageTF()
//    }
//}
