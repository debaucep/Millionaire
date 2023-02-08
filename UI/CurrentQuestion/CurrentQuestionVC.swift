//
//  CurrentQuestionVC.swift
//  Millionaire
//
//  Created by dmitry shcherba on 07.02.2023.
//

import UIKit

class CurrentQuestionVC: UIViewController {
    
    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var questionText: UILabel!
    
    @IBOutlet weak var questionNumber: UILabel!
    
    @IBOutlet weak var moneyCount: UILabel!
    
    
    @IBOutlet weak var fiftyFiftyHelp: UIButton!
    
    @IBOutlet weak var audienceHelp: UIButton!
    
    @IBOutlet weak var friendsHelp: UIButton!
    
    
    
    
    @IBAction func choicePressed(_ sender: UIButton) {
        
    }
    
    
    @IBAction func helpPressed(_ sender: UIButton) {
        //the help is shown and the image of button is crossed with red lines
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}


