//
//  Hints.swift
//  Millionaire
//
//  Created by dmitry shcherba on 07.02.2023.
//

import Foundation

struct Hint {
  
  //Method returns two options that could be excluded
  static func fiftyFifty(for question: Question) -> [String] {
    let wrongAnswers = remainedAnswers(in: question)
    let result = wrongAnswers.shuffled().prefix(upTo: 2).map { String($0) }
    return result
  }
  
  /* Method returns Dictionary that contains text of answers and corresponding percent number.
   It is right with 70% chance rate */
  static func auditoryHelp(for question: Question) -> [String: Int]{
    let randomizer = Int.random(in: 1...10)
    guard randomizer <= 3, let wrongAnswer = remainedAnswers(in: question).randomElement() else {
      return makeAuditoryResult(leadAnswer: question.answer, for: question) }
    let result = makeAuditoryResult(leadAnswer: wrongAnswer, for: question)
    return result
  }
  
  //Method returns text of answer (it is right with 80% chance rate)
  static func friendCall(for question: Question) -> String {
    let randomizer = Int.random(in: 1...10)
    guard randomizer <= 2 else { return question.answer }
    let wrongAnswers = remainedAnswers(in: question)
    guard let result = wrongAnswers.randomElement() else { return question.answer }
    return result
  }
  
  //MARK: - Private generating methods
  private static func remainedAnswers(in question: Question) -> [String] {
    question.options.filter { $0 != question.answer }
  }
  
  private static func generateChartResults() -> (lead: Int, trail: [Int]) {
    var trailAnswers: [Int] = Array(repeating: 0, count: 3)
    let leadAnswer = Int.random(in: 32...87)
    var reminder = 100 - leadAnswer
    for i in 0..<trailAnswers.count - 1 {
      let percent = Int.random(in: 0...reminder)
      reminder -= percent
      trailAnswers[i] = percent
    }
    trailAnswers[2] = reminder
    trailAnswers.shuffle()
    return (leadAnswer, trailAnswers)
  }
  
  private static func makeAuditoryResult(leadAnswer: String, for question: Question) -> [String: Int] {
    var results: [String: Int] = [:]
    let chartResults = generateChartResults()
    let trailingAnswers = question.options.filter { $0 != leadAnswer }
    results[leadAnswer] = chartResults.lead
    for (index, answer) in trailingAnswers.enumerated() {
      results[answer] = chartResults.trail[index]
    }
    return results
  }
  
}
