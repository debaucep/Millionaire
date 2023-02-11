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
  var answerButtons: [UIButton] = []
  
  @IBOutlet weak var logoImage: UIImageView!
  @IBOutlet weak var questionText: UILabel!
  @IBOutlet weak var questionNumber: UILabel!
  @IBOutlet weak var moneyCount: UILabel!
  
  @IBOutlet weak var fiftyFiftyHelp: UIButton!
  @IBOutlet weak var audienceHelp: UIButton!
  @IBOutlet weak var friendsHelp: UIButton!
  @IBOutlet weak var timerLabel: UILabel!
  
  @IBOutlet weak var fiftyFiftyImage: UIImageView!
  @IBOutlet weak var audienceHelpImage: UIImageView!
  @IBOutlet weak var friendsHelpImage: UIImageView!
  
  @IBOutlet weak var answerA: UIButton!
  @IBOutlet weak var answerB: UIButton!
  @IBOutlet weak var answerC: UIButton!
  @IBOutlet weak var answerD: UIButton!
  
  var timer = Timer()
  // 5 is made only for test purpose. come back to 30 before release
  var timerCounter = 0
  var currentQuestion = 0
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fiftyFiftyHelp.setTitle("50/50", for: .normal)
    audienceHelp.setTitle("Audience Help", for: .normal)
    friendsHelp.setTitle("Friends Help", for: .normal)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateUI()
    if currentQuestion < 14 {
      currentQuestion += 1
    }
  }
  
  func updateUI() {
    answerButtons = [answerA, answerB, answerC, answerD]
    answerButtons.forEach { $0.isUserInteractionEnabled = true }
    question = questionFetcher.getCurrentQuestion(with: currentQuestion)
    setAnswers(for: question)
    questionText.text = question?.text
    questionNumber.text = String("Question \(currentQuestion + 1)")
    guard let money = question?.questionDict[currentQuestion + 1] else { return }
    moneyCount.text = String(money)
    
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
      if self.timerCounter > 0 {
        //print ("\(self.secondsRemaining) seconds")
        self.timerLabel.text = String(self.timerCounter)
        self.timerCounter -= 1
      } else {
        self.timer.invalidate()
        self.timeIsOver()
        // And consider player answered WRONG!
      }
    }
    timerCounter = 30
    timerLabel.text = String(timerCounter)
    playSound("BackroundMusicPlayerIsThinking")
  }
  
  @IBAction func choicePressed(_ sender: UIButton) {
    stopSound()
    let answer = prepareToCompare(title: sender.currentTitle)
    let result = isAnswerTrue(answer: answer)
    changeColor(for: sender, result: result)
    if result {
      timer.invalidate()
      playSound("AnsweredRight")
    } else {
      timer.invalidate()
      playSound("AnsweredWrong")
    }
    
  }
  
  @IBAction func helpPressed(_ sender: UIButton) {
    guard let title = sender.currentTitle else { return }
    applyHint(for: title)
    turnHintOff(for: sender)
  }
  
  //MARK: - private methods with logic
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
  
  private func changeColor(for control: UIControl, result: Bool) {
    DispatchQueue.main.asyncAfter(deadline: .now()) {
      result ? (control.tintColor = .systemGreen) : (control.tintColor = .systemRed)
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
      control.tintColor = .systemBlue
    }
  }
  
  private func timeIsOver() {
    let storyboard = UIStoryboard(name: "GameProgressSB", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "GameProgressVC") as! GameProgressVC
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true)
    playSound("AnsweredWrong")
  }
  
}

//MARK: - Hints logic
extension CurrentQuestionVC {
  
  private func turnHintOff(for sender: UIButton) {
    sender.isUserInteractionEnabled = false
    sender.isHidden = true
    switch title {
    case "50/50":
      fiftyFiftyImage.image = UIImage(named: "Logo")
    case "Audience Help":
      audienceHelpImage.image = UIImage(named: "Logo")
    case "Friends Help":
      friendsHelpImage.image = UIImage(named: "Logo")
    default: debugPrint("Unexpected case")
    }
  }
  
  private func applyHint(for senderTitle: String) {
    guard let question = question else { return }
    let answer = question.answer
    
    switch senderTitle {
    case "50/50":
      let options = defineRemainedAnswers()
      let wrongAnswers = Hint.fiftyFifty(for: options, with: answer)
      wrongAnswers.forEach {
        let button = defineAnswerButton(withTitle: $0)
        button?.setTitle("", for: .normal)
        button?.isUserInteractionEnabled = false
        answerButtons.removeAll(where: {$0 == button})
      }
      
    case "Audience Help":
      let options = defineRemainedAnswers()
      let answer = Hint.auditoryHelp(for: options, with: answer)
      let alert = UIAlertController(title: "Auditory's choice is:", message: answer, preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Ok", style: .default)
      alert.addAction(okAction)
      self.present(alert, animated: true)
      
    case "Friends Help":
      let options = defineRemainedAnswers()
      let answer = Hint.friendCall(for: options, with: answer)
      let button = defineAnswerButton(withTitle: answer)
      button?.tintColor = .systemYellow
      
    default: print("There is no hints")
    }
  }
  
  private func defineAnswerButton(withTitle title: String) -> UIButton? {
    answerButtons.filter({ prepareToCompare(title: $0.currentTitle) == title }).first
  }
  
  private func defineRemainedAnswers() -> [String] {
    let result = answerButtons.map { prepareToCompare(title: $0.currentTitle) }
    return result
  }
  
  private func prepareToCompare(title: String?) -> String {
    var answerSeparated = title?.split(separator: " ")
    answerSeparated?.removeFirst()
    guard let answerSubstring = answerSeparated?.joined(separator: " ") else { return "Error"}
    return String(describing: answerSubstring)
  }
  
}

//MARK: - Стоит вынести в отдельный файл, вероятно позже можно будет расширить функционал
struct QuestionFetcher {
  private let quizBrain = QuizBrain()
  
  func getCurrentQuestion(with number: Int) -> Question {
    return quizBrain.quiz[number]
  }
  
}
