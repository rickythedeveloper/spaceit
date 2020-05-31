//
//  CardSearchSystem.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 22/05/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import Foundation

enum CardSearchSystem: String, CaseIterable {
    case byWholePhrase
    case bySeperateWords
    
    func text() -> String {
        switch self {
        case .byWholePhrase:
            return "By Whole Phrase"
        case .bySeperateWords:
            return "By Seperate Words"
        }
    }
    
    func filter(tasks: [TaskSaved], text: String) -> [TaskSaved] {
        switch self {
        case .byWholePhrase:
            return tasks.filterByWord(searchPhrase: text)
        case .bySeperateWords:
            return tasks.filterByKeywords(text.seperatedWords())
        }
    }
    
    static func system(for index: Int) -> CardSearchSystem {
        switch index {
        case 0:
            return .byWholePhrase
        default:
            return .bySeperateWords
        }
    }
}
