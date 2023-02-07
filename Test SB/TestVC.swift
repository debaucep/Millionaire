//
//  TestVC.swift
//  Millionaire
//
//  Created by dmitry shcherba on 06.02.2023.
//

import UIKit
import Foundation

class ViewControllerNewTest: UIViewController {


    @IBOutlet weak var testButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        playSound("AnsweredRight")
        
    }
    
    
}
