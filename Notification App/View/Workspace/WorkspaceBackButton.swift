//
//  WorkspaceBackButton.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 24/11/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct WorkspaceBackButton: View {
    
    var includesDeselect: Bool
    var canGoBack: Bool
    var backAction: () -> Void
    var deselectAction: () -> Void = {}
    
    var body: some View {
        HStack {
            if self.canGoBack {
                Button(action: self.backAction) {
                    Image(systemName: "chevron.left")
                        .padding([.trailing, .top, .bottom])
                }
            }
            
            if self.includesDeselect {
                Button(action: self.deselectAction) {
                    Text("Deselect")
                        .foregroundColor(.red)
                }
            }
            
            EmptyView()
        }
    }
}

//struct WorkspaceBackButton_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkspaceBackButton()
//    }
//}
