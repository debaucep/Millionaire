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
  
  /*need to connect these three outlets to storyboard
   @IBOutlet weak var fiftyFiftyImage: UIImageView!
   @IBOutlet weak var audienceHelpImage: UIImageView!
   @IBOutlet weak var friendsHelpImage: UIImageView!
   */
    
  @IBOutlet weak var answerA: UIButton!
  @IBOutlet weak var answerB: UIButton!
  @IBOutlet weak var answerC: UIButton!
  @IBOutlet weak var answerD: UIButton!
  
  var timerCounter = 5
  
  // 5 is made only for test purpose. come back to 30 before release
var timer = Timer ()
  override func viewDidLoad() {
    super.viewDidLoad()
    answerButtons = [answerA, answerB, answerC, answerD]
    fiftyFiftyHelp.setTitle("50/50", for: .normal)
    audienceHelp.setTitle("Audience Help", for: .normal)
    friendsHelp.setTitle("Friends Help", for: .normal)
    
    question = questionFetcher.getCurrentQuestion(with: 0)
    setAnswers(for: question)
    
    timerLabel.text = String (timerCounter)
    
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
      if self.timerCounter > 0 {
        //print ("\(self.secondsRemaining) seconds")
        self.timerLabel.text = String (self.timerCounter)
        self.timerCounter -= 1
      } else {
        Timer.invalidate()
        self.timeIsOver()
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
    // uncomment if corresponding outlets were connected
    //    switch title {
    //    case "50/50":
    //      fiftyFiftyImage.image = UIImage(named: "Logo")
    //    case "Audience Help":
    //      audienceHelpImage.image = UIImage(named: "Logo")
    //    case "Friends Help":
    //      friendsHelpImage.image = UIImage(named: "Logo")
    //    default: debugPrint("Unexpected case")
    //    }
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
    let answerSeparated = title?.split(separator: " ")
    guard let answerSubstring = answerSeparated?.last else { return "Error"}
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
