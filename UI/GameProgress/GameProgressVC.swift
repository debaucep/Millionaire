//
//  GameProgressVC.swift
//  Millionaire
//
//  Created by dmitry shcherba on 07.02.2023.
//

import UIKit

class GameProgressVC: UIViewController {
    @IBOutlet weak var question1: UIImageView!
    @IBOutlet weak var question2: UIImageView!
    @IBOutlet weak var question3: UIImageView!
    @IBOutlet weak var question4: UIImageView!
    @IBOutlet weak var question5: UIImageView!
    @IBOutlet weak var question6: UIImageView!
    @IBOutlet weak var question7: UIImageView!
    @IBOutlet weak var question8: UIImageView!
    @IBOutlet weak var question9: UIImageView!
    @IBOutlet weak var question10: UIImageView!
    @IBOutlet weak var question11: UIImageView!
    @IBOutlet weak var question12: UIImageView!
    @IBOutlet weak var question13: UIImageView!
    @IBOutlet weak var question14: UIImageView!
    @IBOutlet weak var question15: UIImageView!
    @IBOutlet weak var backToMenu: UIButton!
    
    var listOfViews = [UIImageView]()
    var timerProgress = Timer ()
    var timerProgressCounter = 5.0
    var questionNumber = 0
    var resultBool = false
    var currentSum = 0
    var safeSum = 0
    var isGameFinished = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if questionNumber == 15 {
            isGameFinished = true
        }
        
        if resultBool && !isGameFinished {
            timerProgress = Timer.scheduledTimer(withTimeInterval: timerProgressCounter, repeats: true) { (Timer) in
                if self.timerProgressCounter > 0 {
                    //            print ("\(self.timerProgressCounter) seconds")
                    //            self.timerProgressCounter -= 1
                    
                    self.dismiss(animated: true)
                    stopSound()
                    Timer.invalidate()
                    //          } else {
                    //            Timer.invalidate()
                    // And consider player answered WRONG!
                }
            }
        }
    }
    
    @IBAction func backToMenuPressed(_ sender: UIButton) {
        performSegue(withIdentifier: SegueId.toMainScreen, sender: sender)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isGameFinished {
            showGameResult()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == SegueId.toMainScreen else { return }
        let destination = segue.destination as! MainScreenVC
        destination.modalPresentationStyle = .fullScreen
    }
    
    func setup(with questionNumber: Int, resultBool: Bool, currentSum: Int, safeSum: Int) {
        self.questionNumber = questionNumber
        self.resultBool = resultBool
        self.currentSum = currentSum
        self.safeSum = safeSum
    }
    //MARK: - Private methods
    private func setupUI() {
        backToMenu.isHidden = true
        backToMenu.isUserInteractionEnabled = false
        listOfViews = [question1, question2, question3, question4, question5, question6, question7, question8, question9, question10, question11, question12, question13, question14, question15]
        let imageView = listOfViews[questionNumber - 1]
        if resultBool {
            questionNumber < 15 ? (imageView.image = UIImage(named: "LineGreen")) : (imageView.image = UIImage(named: "LineYellow"))
        } else {
            imageView.image = UIImage(named: "LineRed")
        }
    }
    
    private func showGameResult() {
        let title = max(currentSum, safeSum)
        var alert = UIAlertController(title: "\(title) RUB", message: "Is your winnings", preferredStyle: .alert)
        var okAction = UIAlertAction(title: "Hurray!", style: .default)
        switch title {
        case 0:
            okAction = UIAlertAction(title: "Meh...", style: .default)
        case 1000000:
            okAction = UIAlertAction(title: "Hurray!!!", style: .default)
            alert = UIAlertController(title: "1000000 RUB", message: "You have won the main prize, congratulations!", preferredStyle: .alert)
        default:
            okAction = UIAlertAction(title: "Got it!", style: .default)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
        backToMenu.isHidden = false
        backToMenu.isUserInteractionEnabled = true
    }
}
