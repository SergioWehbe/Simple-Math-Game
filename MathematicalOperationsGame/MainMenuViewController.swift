//
//  MainMenuViewController.swift
//  MathematicalOperationsGame
//
//  Created by Sergio Wehbe on 04/05/2022.
//

import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Title at the top
        let gameTitleLayoutGuide = UILayoutGuide()
        view.addLayoutGuide(gameTitleLayoutGuide)
        
        let gameTitleLabel = UILabel()
        gameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        gameTitleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        gameTitleLabel.text = "Simple Math Game"
        view.addSubview(gameTitleLabel)
        
        // Menu at the center
        let centerLayoutGuide = UILayoutGuide()
        view.addLayoutGuide(centerLayoutGuide)
        
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.buttonSize = .large
        buttonConfiguration.cornerStyle = .medium
        
        let infiniteModeButton = UIButton(type: .system)
        infiniteModeButton.translatesAutoresizingMaskIntoConstraints = false
        infiniteModeButton.setTitle("Infinite Mode", for: .normal)
        infiniteModeButton.addTarget(self, action: #selector(onPlay(_:)), for: .touchUpInside)
        infiniteModeButton.configuration = buttonConfiguration
        view.addSubview(infiniteModeButton)
        
        let timedModeButton = UIButton(type: .system)
        timedModeButton.translatesAutoresizingMaskIntoConstraints = false
        timedModeButton.setTitle("Timed Mode", for: .normal)
        timedModeButton.addTarget(self, action: #selector(onPlay(_:)), for: .touchUpInside)
        timedModeButton.configuration = buttonConfiguration
        view.addSubview(timedModeButton)
        
        
        let constraints = [
            // Title at the top
            gameTitleLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gameTitleLayoutGuide.bottomAnchor.constraint(equalTo: centerLayoutGuide.topAnchor),
            
            gameTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameTitleLabel.centerYAnchor.constraint(equalTo: gameTitleLayoutGuide.centerYAnchor),
            
            // Menu at the center
            centerLayoutGuide.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            infiniteModeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            infiniteModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infiniteModeButton.topAnchor.constraint(equalTo: centerLayoutGuide.topAnchor),

            timedModeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            timedModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timedModeButton.topAnchor.constraint(equalTo: infiniteModeButton.bottomAnchor, constant: 20),
            timedModeButton.bottomAnchor.constraint(equalTo: centerLayoutGuide.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @IBAction private func onPlay(_ sender: UIButton) {
        let gameViewController = GameViewController()
        gameViewController.modalPresentationStyle = .fullScreen
        gameViewController.modalTransitionStyle = .crossDissolve

        self.present(gameViewController, animated: true, completion: nil)
    }
}
