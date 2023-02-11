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
        rulesText.font = UIFont.systemFont(ofSize: 18)
        rulesText.sizeToFit()
        rulesText.isEditable = false
        rulesText.isScrollEnabled = true
        
        // note Image should be placed into assets before the procedure
        
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background1")!)
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background1")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
   
        
        
    }
}

