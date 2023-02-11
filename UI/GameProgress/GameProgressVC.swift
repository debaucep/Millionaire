//
//  GameProgressVC.swift
//  Millionaire
//
//  Created by dmitry shcherba on 07.02.2023.
//

import UIKit

class GameProgressVC: UIViewController {
    
    @IBOutlet weak var Question1: UIImageView!
    @IBOutlet weak var Question2: UIImageView!
    @IBOutlet weak var Question3: UIImageView!
    @IBOutlet weak var Question4: UIImageView!
    @IBOutlet weak var Question5: UIImageView!
    @IBOutlet weak var Question6: UIImageView!
    @IBOutlet weak var Question7: UIImageView!
    @IBOutlet weak var Question8: UIImageView!
    @IBOutlet weak var Question9: UIImageView!
    @IBOutlet weak var Question10: UIImageView!
    @IBOutlet weak var Question11: UIImageView!
    @IBOutlet weak var Question12: UIImageView!
    @IBOutlet weak var Question13: UIImageView!
    @IBOutlet weak var Question14: UIImageView!
    @IBOutlet weak var Question15: UIImageView!
    
    var listOfViews = [UIImageView]()
    let currentLevel = 0
    var timerProgress = Timer ()
    var timerProgressCounter = 5.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLevel()
        
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
    
    private func setupUI() {
        
        for view in listOfViews {
            listOfViews.append(view)
        }
    }
    
    private func setupLevel() {
        switch currentLevel {
        case 1...15: listOfViews[currentLevel].image = UIImage(named: "LineGreen")
        default: return
        }
    }
}
