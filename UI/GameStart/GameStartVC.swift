//
//  GameStartVC.swift
//  Millionaire
//
//  Created by dmitry shcherba on 07.02.2023.
//
import UIKit

class GameStartVC: UIViewController {
    var player = Player(name: "", winnings: 0)
    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
    }

    @IBAction func registerButton(_ sender: UIButton) {
        player.name = nameField.text ?? "John Doe"
        performSegue(withIdentifier: SegueId.toCurrentQuestion, sender: sender)
    }
    
    //MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == SegueId.toCurrentQuestion else { return }
        let destination = segue.destination as! CurrentQuestionVC
        destination.setupPlayer(name: player.name)
    }
    //MARK: - Private setup methods
    private func setupBackground() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background2")!)
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background2")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
}
