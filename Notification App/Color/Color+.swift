//
//  Color+.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 13/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import SwiftUI

extension Color {
//    static func random() -> Color {
//        let colour = Color(red: Double.randomForColour(), green: Double.randomForColour(), blue: Double.randomForColour())
//        return colour
//    }
    
    static func randomVibrantColour() -> Color {
        let lowerThreshold = 0.3
        let upperThreshold = 0.8
        
        let block = (upperThreshold - lowerThreshold) / 7
        
        let min1 = lowerThreshold
        let max1 = lowerThreshold +  block * 3
        
        let min2 = lowerThreshold + block * 2
        let max2 = lowerThreshold + block * 5
        
        let min3 = lowerThreshold + block * 4
        let max3 = upperThreshold
        
        var valuePairs = [[min1, max1], [min2, max2], [min3, max3]]
        valuePairs.shuffle()
        
        let colour = Color(
            red: Double.random(in: valuePairs[0][0]...valuePairs[0][1]),
            green: Double.random(in: valuePairs[1][0]...valuePairs[1][1]),
            blue: Double.random(in: valuePairs[2][0]...valuePairs[2][1]))
        
        return colour        
    }
}

//extension Double {
//    static func randomForColour() -> Double {
//        return Double.random(in: 0.3...0.8)
//    }
//}
