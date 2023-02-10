//
//  CurrentQuestionVC.swift
//  Millionaire
//
//  Created by dmitry shcherba on 07.02.2023.
//

import UIKit

class CurrentQuestionVC: UIViewController {
  let questionFetcher = QuestionFetcher()
  var question: Question?
  
  @IBOutlet weak var logoImage: UIImageView!
  
  @IBOutlet weak var questionText: UILabel!
  
  @IBOutlet weak var questionNumber: UILabel!
  
  @IBOutlet weak var moneyCount: UILabel!
  
  
  @IBOutlet weak var fiftyFiftyHelp: UIButton!
  
  @IBOutlet weak var audienceHelp: UIButton!
  
  @IBOutlet weak var friendsHelp: UIButton!
  
  @IBOutlet weak var timerLabel: UILabel!
  
  @IBOutlet weak var answerA: UIButton!
  @IBOutlet weak var answerB: UIButton!
  @IBOutlet weak var answerC: UIButton!
  @IBOutlet weak var answerD: UIButton!
  
  var timerCounter = 5
  
  // 5 is made only for test purpose. come back to 30 before release
  
  override func viewDidLoad() {
    super.viewDidLoad()
    question = questionFetcher.getCurrentQuestion(with: 0)
    setAnswers(for: question)
    
    timerLabel.text = String (timerCounter)
    
    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
      if self.timerCounter > 0 {
        //print ("\(self.secondsRemaining) seconds")
        self.timerLabel.text = String (self.timerCounter)
        self.timerCounter -= 1
      } else {
        Timer.invalidate()
        // And consider player answered WRONG!
      }
    }
    
    playSound("BackroundMusicPlayerIsThinking")
    
  }
  
  @IBAction func choicePressed(_ sender: UIButton) {
    stopSound()
    let answer = prepareToCompare(title: sender.currentTitle)
    let result = isAnswerTrue(answer: answer)
    changeColor(for: sender, result: result)
  }
  
  
  @IBAction func helpPressed(_ sender: UIButton) {
    //the help is shown and the image of button is crossed with red lines
  }
  
  private func setAnswers(for question: Question?) {
    guard let question = question else { return }
    answerA.setTitle("A. \(question.options[0])", for: .normal)
    answerB.setTitle("B. \(question.options[1])", for: .normal)
    answerC.setTitle("C. \(question.options[2])", for: .normal)
    answerD.setTitle("D. \(question.options[3])", for: .normal)
  }
  
  private func isAnswerTrue(answer: String) -> Bool {
    guard let trueAnswer = question?.answer else { return false}
    return answer == trueAnswer ? true : false
  }
  
  private func prepareToCompare(title: String?) -> String {
    let answerSeparated = title?.split(separator: " ")
    guard let answerSubstring = answerSeparated?[1] else { return "Error"}
    return String(describing: answerSubstring)
  }
  
  private func changeColor(for control: UIControl, result: Bool) {
    DispatchQueue.main.asyncAfter(deadline: .now()) {
      result ? (control.tintColor = .systemGreen) : (control.tintColor = .systemRed)
    }
  }
  
}

// Стоит вынести в отдельный файл, вероятно позже можно будет расширить функционал
struct QuestionFetcher {
  private let quizBrain = QuizBrain()
  
  func getCurrentQuestion(with number: Int) -> Question {
    return quizBrain.quiz[number]
  }
  
}
