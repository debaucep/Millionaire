//
//  MainScreenVC.swift
//  Millionaire
//
//  Created by Aleksei Zhadaev on 06.02.2023.
//

import UIKit

final class MainScreenVC: UIViewController {
  private enum SegueId {
    static let gameRules = "toGameRules"
    static let startGame = "toStartGame"
  }
  
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var welcomeLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background1")!)
      UIGraphicsBeginImageContext(self.view.frame.size)
      UIImage(named: "background1")?.draw(in: self.view.bounds)
      let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext()
      self.view.backgroundColor = UIColor(patternImage: image)
  }
  
  @IBAction func rulesButtonPressed(_ sender: UIButton) {
    
  }
  
  @IBAction func startButtonPressed(_ sender: UIButton) {
    
  }
  
  private func setupUI() {
    logoImageView.layer.cornerRadius = logoImageView.frame.height / 2
  }
}

//MARK: - Segue setup

//extension MainScreenVC {
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//      if segue.identifier == SegueId.gameRules {
//        // let destinationVC = segue.destination as ...
//      } else if segue.identifier == SegueId.startGame {
//        // let destinationVC = segue.destination as ...
//      }
//    }
  
//}
