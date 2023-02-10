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


var questionDict = [
    1 : 100,
    2 : 200,
    3 : 300,
    4 : 500,
    5 : 1_000, // safe summ
    6 : 2_000,
    7 : 4_000,
    8 : 8_000,
    9 : 16_000,
    10 : 32_000, // safe sum
    11 : 64_000,
    12 : 125_000,
    13 : 250_000,
    14 : 500_000,
    15 : 1_000_000 // win
]
