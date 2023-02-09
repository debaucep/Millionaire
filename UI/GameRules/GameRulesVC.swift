//
//  GameRulesVC.swift
//  Millionaire
//
//  Created by dmitry shcherba on 07.02.2023.
//

import UIKit
import Foundation


class GameRulesVC: UIViewController {
    
    @IBOutlet weak var rulesText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let quizRules = QuizRules()
        let text = quizRules.text
        rulesText.text = text
        rulesText.font = UIFont.systemFont(ofSize: 15)
        rulesText.sizeToFit()
        rulesText.isEditable = false
        rulesText.isScrollEnabled = true
        
        
    }
}

