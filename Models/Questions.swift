//
//  Questions.swift
//  QuestionsMillionaire
//
//  Created by Dauletkhanova Saniya on 07.02.2023.
//

import Foundation

struct Question {
    let text: String
    let options: [String]
    let answer: String
    
    init(q: String, a: [String], correctAnswer: String) {
        text = q
        options = a
        answer = correctAnswer
    
    }
}
