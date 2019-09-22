//
//  PageNameEditView.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 22/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

struct PageNameEditView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Page.fetchRequest()) var pages: FetchedResults<Page>
    
    var pageID: UUID
    
    @State private var name = ""
    
    var body: some View {
        VStack {
            TextField("Page Name", text: self.$name)
                .padding(5)
                .background(Color.gray)
                .cornerRadius(10.0)
                .padding()
            Button(action: self.buttonPressed) {
                Image(systemName: "checkmark")
            }.disabled(!self.name.hasContent())
        }.onAppear(perform: self.setup)
        .padding()
        .font(.title)
    }
    
    private func setup() {
        guard let thisPage = pages.page(id: pageID) else { return }
        self.name = thisPage.name
    }
    
    private func buttonPressed() {
        guard let thisPage = pages.page(id: pageID) else { return }
        guard name.hasContent() else {return}
        thisPage.name = self.name
        print(managedObjectContext.hasChanges)
        self.managedObjectContext.saveContext()
        self.presentationMode.wrappedValue.dismiss()
    }
}
