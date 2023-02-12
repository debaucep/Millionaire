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
    var timer = Timer()
    var timerCounter = 0
    var currentQuestion = 0
    var resultBool = false
    var currentSum = 0
    var safeSum = 0
    var player = Player(name: "", winnings: 0)
    
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
    @IBOutlet weak var takeMoney: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupHints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        if currentQuestion <= 14 {
            currentQuestion += 1
        }
    }
    
    func setupPlayer(name: String) {
        name == "" ? (player.name = "John Doe") : (player.name = name)
    }
    
    @IBAction func choicePressed(_ sender: UIButton) {
        answerButtons.forEach { $0.isUserInteractionEnabled = false }
        takeMoney.isUserInteractionEnabled = false
        timer.invalidate()
        stopSound()
        let answer = prepareToCompare(title: sender.currentTitle)
        sender.tintColor = .systemYellow
        playSound("AnswerIsSubmitted")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
            resultBool = isAnswerTrue(answer: answer)
            changeColor(for: sender, result: resultBool)
            if resultBool {
                timer.invalidate()
                calculateSum()
                currentQuestion < 15 ? playSound("AnsweredRight") : playSound("WonMillion")
                performSegue(withIdentifier: SegueId.toGameProgress, sender: sender)
            } else {
                timer.invalidate()
                gameIsOver()
            }
        }
    }
    
    @IBAction func helpPressed(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        applyHint(for: title)
        turnHintOff(for: sender)
    }
    
    @IBAction func takeMoneyPressed(_ sender: UIButton) {
        timer.invalidate()
        stopSound()
        let storyboard = UIStoryboard(name: "GameProgressSB", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GameProgressVC") as! GameProgressVC
        vc.modalPresentationStyle = .fullScreen
        vc.setup(with: currentQuestion, resultBool: true, currentSum: currentSum, safeSum: safeSum)
        vc.isGameFinished = true
        present(vc, animated: true)
        playSound("AnsweredRight")
    }
    
    
    //MARK: - routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == SegueId.toGameProgress else { return }
        let destination = segue.destination as! GameProgressVC
        destination.setup(with: currentQuestion, resultBool: resultBool, currentSum: currentSum, safeSum: safeSum)
    }
    
    private func gameIsOver() {
        calculateSum()
        let storyboard = UIStoryboard(name: "GameProgressSB", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GameProgressVC") as! GameProgressVC
        vc.modalPresentationStyle = .fullScreen
        vc.setup(with: currentQuestion, resultBool: resultBool, currentSum: currentSum, safeSum: safeSum)
        vc.isGameFinished = true
        present(vc, animated: true)
        playSound("AnsweredWrong")
    }
    
    //MARK: - private methods with logic
    private func updateUI() {
        answerButtons = [answerA, answerB, answerC, answerD]
        answerButtons.forEach { $0.isUserInteractionEnabled = true }
        takeMoney.isUserInteractionEnabled = true
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
                self.gameIsOver()
                // And consider player answered WRONG!
            }
        }
        timerCounter = 30
        timerLabel.text = String(timerCounter)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            playSound("BackroundMusicPlayerIsThinking")
        }
    }
    
    private func setupBackground() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background1")!)
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background1")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    private func setupHints() {
        fiftyFiftyHelp.setTitle("50/50", for: .normal)
        audienceHelp.setTitle("Audience Help", for: .normal)
        friendsHelp.setTitle("Friends Help", for: .normal)
        fiftyFiftyImage.image = UIImage(named: "50_50_LQ")
        audienceHelpImage.image = UIImage(named: "Audience_LQ")
        friendsHelpImage.image = UIImage(named: "CallBuddy_LQ")
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
    
    private func changeColor(for control: UIControl, result: Bool) {
        result ? (control.tintColor = .systemGreen) : (control.tintColor = .systemRed)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            control.tintColor = .systemBlue
        }
    }
    
    private func calculateSum() {
        guard let sum = question?.questionDict[currentQuestion] else { return }
        if resultBool {
            currentSum = sum
        } else {
            currentSum = 0
        }
        
        if currentQuestion == 5 {
            safeSum = 1000
        } else if currentQuestion == 10 {
            safeSum = 32000
        }
    }
}

//MARK: - Hints logic
extension CurrentQuestionVC {
    
    private func turnHintOff(for sender: UIButton) {
        sender.isUserInteractionEnabled = false
        sender.isHidden = true
        switch sender.currentTitle {
        case "50/50":
            fiftyFiftyImage.layer.opacity = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.fiftyFiftyImage.layer.opacity = 1
                self.fiftyFiftyImage.image = UIImage(named: "50_50_CR")
            }
        case "Audience Help":
            audienceHelpImage.layer.opacity = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.audienceHelpImage.layer.opacity = 1
                self.audienceHelpImage.image = UIImage(named: "Audience_CR")
            }
        case "Friends Help":
            friendsHelpImage.layer.opacity = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.friendsHelpImage.layer.opacity = 1
                self.friendsHelpImage.image = UIImage(named: "CallBuddy_CR")
            }
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
            let alert = UIAlertController(title: "Hi, \(player.name), I suppose it's", message: answer, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
            
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
