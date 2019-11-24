//
//  PageNameCell.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 24/11/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct PageNameCell: View {
    
    var page: Page
    var isFirst: Bool = false
    
    var body: some View {
        HStack {
            Text(page.name)
            
            Spacer()
            VStack {
                if self.isFirst {
                    Text("due")
                      .font(.caption)
                }
                Text(String(page.nOfDueConcepts()))
            }.foregroundColor(.red)
            
            Group {
                Text("/")
                
                VStack {
                    if self.isFirst {
                        Text("total")
                            .font(.caption)
                    }
                    Text(String(page.nOfConceptsUnder()))
                }
            }.opacity(0.5)
            
        }
    }
}

//struct PageNameCell_Previews: PreviewProvider {
//    static var previews: some View {
//        PageNameCell()
//    }
//}
