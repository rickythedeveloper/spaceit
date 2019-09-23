//
//  TaskSaved+CoreDataClass.swift
//  
//
//  Created by Rintaro Kawagishi on 21/09/2019.
//
//

import Foundation
import CoreData
import SwiftUI


public class TaskSaved: NSManagedObject {
    public var colour: Color = Color.randomVibrantColour()
    public var angle: Angle = Angle.randomSmallAngle()
}
