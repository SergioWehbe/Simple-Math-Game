//
//  MainMenuViewController.swift
//  MathematicalOperationsGame
//
//  Created by Sergio Wehbe on 04/05/2022.
//

import UIKit

final class MainMenuViewController: UIViewController {
    
    private let infiniteModeString = "Infinite Mode"
    private let timeModeString = "Time Mode"
    private let leaderboardsString = "Leaderboards"

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
        buttonConfiguration.imagePadding = 5
        
        let infiniteModeButton = UIButton(type: .system)
        infiniteModeButton.translatesAutoresizingMaskIntoConstraints = false
        infiniteModeButton.setTitle(infiniteModeString, for: .normal)
        infiniteModeButton.addTarget(self, action: #selector(onPlay(_:)), for: .touchUpInside)
        infiniteModeButton.configuration = buttonConfiguration
        let infiniteModeButtonImage = UIImage(systemName: "infinity")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        infiniteModeButton.setImage(infiniteModeButtonImage, for: .normal)
        view.addSubview(infiniteModeButton)
        
        let timeModeButton = UIButton(type: .system)
        timeModeButton.translatesAutoresizingMaskIntoConstraints = false
        timeModeButton.setTitle(timeModeString, for: .normal)
        timeModeButton.addTarget(self, action: #selector(onPlay(_:)), for: .touchUpInside)
        timeModeButton.configuration = buttonConfiguration
        let timeModeButtonImage = UIImage(systemName: "clock")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        timeModeButton.setImage(timeModeButtonImage, for: .normal)
        view.addSubview(timeModeButton)
        
        // Button at the bottom
        let leaderboardsButton = UIButton(type: .system)
        leaderboardsButton.translatesAutoresizingMaskIntoConstraints = false
        leaderboardsButton.setTitle(leaderboardsString, for: .normal)
        leaderboardsButton.addTarget(self, action: #selector(onLeaderboardsButtonTapped), for: .touchUpInside)
        leaderboardsButton.configuration = buttonConfiguration
        let leaderboardsButtonImage = UIImage(systemName: "person.3")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        leaderboardsButton.setImage(leaderboardsButtonImage, for: .normal)
        view.addSubview(leaderboardsButton)
        
        
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

            timeModeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            timeModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeModeButton.topAnchor.constraint(equalTo: infiniteModeButton.bottomAnchor, constant: 20),
            timeModeButton.bottomAnchor.constraint(equalTo: centerLayoutGuide.bottomAnchor),
            
            // Button at the bottom
            leaderboardsButton.widthAnchor.constraint(greaterThanOrEqualTo: view.widthAnchor, multiplier: 0.5),
            leaderboardsButton.heightAnchor.constraint(equalToConstant: 50),
            leaderboardsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            leaderboardsButton.topAnchor.constraint(lessThanOrEqualTo: timeModeButton.bottomAnchor, constant: 150),
            leaderboardsButton.bottomAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func onPlay(_ sender: UIButton) {
        
        var gameMode : GameViewController.GameMode = .time
        
        if let titleButton = sender.currentTitle {
            
            switch titleButton {
            case infiniteModeString:
                gameMode = .infinite
            case timeModeString:
                gameMode = .time
            default:
                gameMode = .time
            }
        }
        
        let gameViewController = GameViewController()
        gameViewController.gameMode = gameMode
        gameViewController.modalPresentationStyle = .fullScreen
        gameViewController.modalTransitionStyle = .crossDissolve

        self.present(gameViewController, animated: true, completion: nil)
    }
    
    @objc private func onLeaderboardsButtonTapped() {
        let scrollViewController = LeaderboardsViewController()
        scrollViewController.modalPresentationStyle = .fullScreen
        scrollViewController.modalTransitionStyle = .crossDissolve

        self.present(scrollViewController, animated: true, completion: nil)
    }
}
