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
    
    @IBOutlet weak var counterLabe: UILabel!
    
    @IBOutlet weak var counterButton: UIButton!
    
   
       
//********************************
       
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        counterLabe.text = "Press Start below"
 
    }


//********************************
    
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        playSound("AnsweredRight")
        
    }
    
    
    var secondsRemaining = 30
    
    
    @IBAction func counterButtonPressed(_ sender: UIButton) {

  
        

        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if self.secondsRemaining > 0 {
                //print ("\(self.secondsRemaining) seconds")
                self.counterLabe.text = String (self.secondsRemaining)
                self.secondsRemaining -= 1
            } else {
                Timer.invalidate()
            }
        }

        
    }
    
    //********************************
    

    
}
