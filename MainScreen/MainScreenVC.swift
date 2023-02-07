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
  }
  
  @IBAction func rulesButtonPressed(_ sender: UIButton) {
    performSegue(withIdentifier: SegueId.gameRules, sender: self)
  }
  
  @IBAction func startButtonPressed(_ sender: UIButton) {
    performSegue(withIdentifier: SegueId.startGame, sender: self)
  }
  
  private func setupUI() {
    logoImageView.layer.cornerRadius = logoImageView.frame.height / 2
  }
}

//MARK: - Segue setup

extension MainScreenVC {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == SegueId.gameRules {
        // let destinationVC = segue.destination as ...
      } else if segue.identifier == SegueId.startGame {
        // let destinationVC = segue.destination as ...
      }
    }
  
}
