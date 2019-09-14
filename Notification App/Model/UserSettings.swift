//
//  UserSettings.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 09/09/2019.
//  Copyright © 2019 Rintaro Kawagishi. All rights reserved.
//

import Foundation

class UserSettings: ObservableObject {
    @Published var remindTimeSettings = [RemindTimeSetting(title: "Right Now", seconds: [1]),
                                         RemindTimeSetting(title: "Tomorrow same time", days: [1]),
                                         RemindTimeSetting(title: "Spaced Repetition", days: [1, 2, 4, 8, 16, 32, 64])]
    
//    @Published var allTaskStore = TaskStore(tasks: [
//        Task(question: "Question 1", answer: "Answer 1"), // not due
//        Task(question: "Dont forget Bernoulli brooooaaaaaaaaa", answer: nil), // not due
//        Task(question: "This is due actually", answer: "Oh boi", lastChecked: Date(timeIntervalSince1970: 100), waitTime: 10000), // due
//        Task(question: "This one too", answer: "oof", lastChecked: Date(timeIntervalSinceNow: -3600*25)), // due
//        Task(question: "This one was created yesterday", answer: "hello", lastChecked: Date(timeIntervalSinceNow: -3600*24*4), waitTime: 260000), // due
//        Task(question: "Structure of something", answer: "Blah blah blah the hexagonal blah balh  adshsaoih oashdhah oiah iasohioa hih io hoiash ahaoih oiahdoi ahoihoiaho doahio a a a s ha id a ah ao", lastChecked: Date(timeIntervalSinceNow: -80000), waitTime: 50000)]) // due
}
