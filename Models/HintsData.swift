//
//  HintsData.swift
//  Millionaire
//
//  Created by dmitry shcherba on 07.02.2023.
//

import Foundation

enum SegueId {
    static let toMainScreen = "toMainScreen"
    static let toGameRules = "toGameRules"
    static let toStartGame = "toStartGame"
    static let toCurrentQuestion = "toCurrentQuestion"
    static let toGameProgress = "toGameProgress"
}

struct QuestionFetcher {
    private let quizBrain = QuizBrain()
    
    func getCurrentQuestion(with number: Int) -> Question {
        return quizBrain.quiz[number]
    }
    
}
