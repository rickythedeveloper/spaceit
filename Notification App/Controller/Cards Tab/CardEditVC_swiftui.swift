//
//  CardEditVC_swiftui.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 05/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI
import UIKit
import CoreData

struct CardEditVCRepresentable: UIViewControllerRepresentable {
    
    var task: TaskSaved
    var managedObjectContext: NSManagedObjectContext
    
    @Binding var showsDeactivate: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> CardEditVC {
        let vc = CardEditVC(task: self.task, managedObjectContext: self.managedObjectContext)
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiVC: CardEditVC, context: Context) {
        uiVC.updateView(showsDeactivate: showsDeactivate)
    }
    
    class Coordinator: NSObject, CardEditVCDelegate {
        var parent: CardEditVCRepresentable
        
        init(_ vcr: CardEditVCRepresentable) {
            self.parent = vcr
        }
        
        func decativatePressed() {
            self.parent.showsDeactivate.toggle()
        }
    }
}

struct CardEditView2: View {
    
    var task: TaskSaved
    var managedObjectContext: NSManagedObjectContext
    
    @State private var showsDeactivate: Bool = true
    
    var body: some View {
        CardEditVCRepresentable(task: self.task, managedObjectContext: self.managedObjectContext, showsDeactivate: self.$showsDeactivate)
            .navigationBarTitle("Edit Card", displayMode: .inline)
    }
}
