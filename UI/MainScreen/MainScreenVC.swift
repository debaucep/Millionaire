//
//  MainScreenVC.swift
//  Millionaire
//
//  Created by Aleksei Zhadaev on 06.02.2023.
//

import UIKit

final class MainScreenVC: UIViewController {
  
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var welcomeLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  @IBAction func rulesButtonPressed(_ sender: UIButton) {
    
  }
  
  @IBAction func startButtonPressed(_ sender: UIButton) {
    
  }
  
  private func setupUI() {
      self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background1")!)
      UIGraphicsBeginImageContext(self.view.frame.size)
      UIImage(named: "background1")?.draw(in: self.view.bounds)
      let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext()
      self.view.backgroundColor = UIColor(patternImage: image)
    
  }
}
