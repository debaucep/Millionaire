//
//  GameStartVC.swift
//  Millionaire
//
//  Created by dmitry shcherba on 07.02.2023.
//
import UIKit

class GameStartVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set background
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background2")!)
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background2")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
    }
    
    
    @IBAction func nameTyping(_ sender: UITextField) {
    }
    

    @IBAction func registerButton(_ sender: UIButton) {
        
        
    }
    

    
}
