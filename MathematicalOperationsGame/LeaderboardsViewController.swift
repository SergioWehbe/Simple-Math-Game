//
//  LeaderboardsViewController.swift
//  MathematicalOperationsGame
//
//  Created by Sergio Wehbe on 09/05/2022.
//

import UIKit

class LeaderboardsViewController: UIViewController {
    
    private let tableView = UITableView()
    private var gameModeSelectedIndex = 0
    
    private var stackView : UIStackView!
    
    private var didGameModeButtonsAllign = false
    private var gameModeButtons = [UIView]()
    private var gameModeButtonsGridConstraints = [NSLayoutConstraint]()
    private var gameModeButtonsAllignedConstraints = [NSLayoutConstraint]()
    private var gameModeButtonsAllignedWithoutScrollViewConstraints = [NSLayoutConstraint]()
    
    private let gameModeStringArray : [String] = [ "Infinite", "Time", "Close Enough", "Co-op" ]
    private let gameModeImageArray : [String] = [ "infinity", "clock", "arrow.down.right.and.arrow.up.left", "person.2" ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let quitButton = UIButton(type: .system)
        quitButton.translatesAutoresizingMaskIntoConstraints = false
        quitButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        quitButton.setTitle("Quit", for: .normal)
        quitButton.addTarget(self, action: #selector(onQuitButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(quitButton)
        
        let leaderboardTitle = UILabel()
        leaderboardTitle.translatesAutoresizingMaskIntoConstraints = false
        leaderboardTitle.font = UIFont.systemFont(ofSize: 20)
        leaderboardTitle.text = "Leaderboards"
        view.addSubview(leaderboardTitle)
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .white
        
        view.addSubview(scrollView)
        view.sendSubviewToBack(scrollView)
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        scrollView.addSubview(stackView)
        scrollView.sendSubviewToBack(stackView)
        
        var constraints = [
            quitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            quitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            leaderboardTitle.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            leaderboardTitle.centerYAnchor.constraint(equalTo: quitButton.centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            scrollView.topAnchor.constraint(equalTo: leaderboardTitle.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: -5),
            scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 5),
            scrollView.heightAnchor.constraint(equalToConstant: 50),
        ]
        
        for index in 0...gameModeStringArray.count-1 {
            let grid = UIButton()
            grid.translatesAutoresizingMaskIntoConstraints = false
            grid.backgroundColor = .white
            let cornerRadius: CGFloat = 10
            grid.layer.cornerRadius = cornerRadius
            grid.layer.shadowColor = UIColor.darkGray.cgColor
            grid.layer.shadowOffset = .zero
            // If shadowPath works, it would significantly improve performance
//            grid.layer.shadowPath = UIBezierPath(roundedRect: grid.bounds, cornerRadius: cornerRadius).cgPath
//            grid.layer.masksToBounds = false
            grid.layer.shadowRadius = 5.0
            grid.layer.shadowOpacity = 0.1
            grid.layer.shouldRasterize = true
            grid.layer.rasterizationScale = UIScreen.main.scale
            grid.addTarget(self, action: #selector(onGridButtonTapped), for: .touchUpInside)
            gameModeButtons.append(grid)
            view.addSubview(grid)
            
            let image = UIImage(systemName: gameModeImageArray[index])
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            grid.addSubview(imageView)
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 16)
            label.text = gameModeStringArray[index]
            grid.addSubview(label)
            
            gameModeButtonsGridConstraints.append(contentsOf: [
                imageView.centerXAnchor.constraint(equalTo: grid.centerXAnchor),
                imageView.topAnchor.constraint(equalTo: grid.topAnchor, constant: 20),
                imageView.widthAnchor.constraint(greaterThanOrEqualTo: grid.widthAnchor, multiplier: 1/2),
                imageView.heightAnchor.constraint(greaterThanOrEqualTo: grid.heightAnchor, multiplier: 1/2),
                
                label.centerXAnchor.constraint(equalTo: grid.centerXAnchor),
                label.bottomAnchor.constraint(equalTo: grid.bottomAnchor, constant: -20)
            ])
            
            gameModeButtonsAllignedConstraints.append(contentsOf: [
                imageView.centerYAnchor.constraint(equalTo: grid.centerYAnchor),
                imageView.firstBaselineAnchor.constraint(equalTo: label.firstBaselineAnchor),
                imageView.leadingAnchor.constraint(equalTo: grid.leadingAnchor, constant: 10),
                
                label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
                label.trailingAnchor.constraint(equalTo: grid.trailingAnchor, constant: -10)
            ])
            
            gameModeButtonsAllignedWithoutScrollViewConstraints.append(contentsOf: [
                gameModeButtons[index].heightAnchor.constraint(equalToConstant: 40),
                index == 0 ?
                gameModeButtons[index].leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor) :
                    gameModeButtons[index].leadingAnchor.constraint(equalTo: gameModeButtons[index-1].trailingAnchor, constant: 5),
                index == 0 ?
                gameModeButtons[index].centerYAnchor.constraint(equalTo: scrollView.centerYAnchor) :
                    gameModeButtons[index].topAnchor.constraint(equalTo: gameModeButtons[index-1].topAnchor),
            ])
            
            
            if index == 0 {
                gameModeButtonsGridConstraints.append(contentsOf: [
                    gameModeButtons[index].leadingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
                    gameModeButtons[index].topAnchor.constraint(equalTo: scrollView.bottomAnchor),
                ])
            }
            else if index % 2 == 0 {
                gameModeButtonsGridConstraints.append(contentsOf: [
                    gameModeButtons[index].leadingAnchor.constraint(equalTo: gameModeButtons[0].leadingAnchor),
                    gameModeButtons[index].topAnchor.constraint(equalTo: gameModeButtons[index-2].bottomAnchor, constant: 10),
                ])
            }
            else {
                
                gameModeButtonsGridConstraints.append(contentsOf: [
                    gameModeButtons[index].leadingAnchor.constraint(equalTo: gameModeButtons[index-1].trailingAnchor, constant: 10),
                    gameModeButtons[index].trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                    gameModeButtons[index].centerYAnchor.constraint(equalTo: gameModeButtons[index-1].centerYAnchor),
                ])
            }
            
            gameModeButtonsGridConstraints.append(contentsOf: [
                gameModeButtons[index].widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1/2, constant: -5),
                gameModeButtons[index].heightAnchor.constraint(equalTo: gameModeButtons[index].widthAnchor),
            ])
        }
        
        constraints.append(contentsOf: gameModeButtonsGridConstraints)
        
        NSLayoutConstraint.activate(constraints)
    }

    @objc private func onGridButtonTapped(_ sender: UIButton) {
        
        if !didGameModeButtonsAllign {
            didGameModeButtonsAllign = true
            
            UIView.animate(withDuration: 0.3, animations: {
                
                NSLayoutConstraint.deactivate(self.gameModeButtonsGridConstraints)
                NSLayoutConstraint.activate(self.gameModeButtonsAllignedConstraints)
                NSLayoutConstraint.activate(self.gameModeButtonsAllignedWithoutScrollViewConstraints)
                
                self.view.layoutIfNeeded()
            }, completion: { _ in
                
                NSLayoutConstraint.deactivate(self.gameModeButtonsAllignedWithoutScrollViewConstraints)
                for button in self.gameModeButtons {
                    button.removeFromSuperview()
                    self.stackView.addArrangedSubview(button)
                }
                self.setupTableView()
            })
        }
        
        if let buttonIndex = gameModeButtons.firstIndex(of: sender) {
            gameModeSelectedIndex = buttonIndex
            tableView.reloadData()
        }
    }
    
    struct PlayerScore {
        let name : String
        let score : Int
    }
    
    private let bestScoreInfinityArray : [PlayerScore] = [
        PlayerScore.init(name: "Sergio", score: Int.random(in: 140...150)),
        PlayerScore.init(name: "Liam", score: Int.random(in: 130...140)),
        PlayerScore.init(name: "Olivia", score: Int.random(in: 120...130)),
        PlayerScore.init(name: "Noah", score: Int.random(in: 110...120)),
        PlayerScore.init(name: "Emma", score: Int.random(in: 100...110)),
        PlayerScore.init(name: "Oliver", score: Int.random(in: 90...100)),
        PlayerScore.init(name: "Charlotte", score: Int.random(in: 80...90)),
    ]
    
    private let bestScoreTimeArray : [PlayerScore] = [
        PlayerScore.init(name: "Isabella", score: Int.random(in: 140...150)),
        PlayerScore.init(name: "Lucas", score: Int.random(in: 130...140)),
        PlayerScore.init(name: "Mia", score: Int.random(in: 120...130)),
        PlayerScore.init(name: "Henry", score: Int.random(in: 110...120)),
        PlayerScore.init(name: "Evelyn", score: Int.random(in: 100...110)),
        PlayerScore.init(name: "Theodore", score: Int.random(in: 90...100)),
        PlayerScore.init(name: "Harper", score: Int.random(in: 80...90)),
    ]
    
    private let bestScoreCloseEnoughArray : [PlayerScore] = [
        PlayerScore.init(name: "Sergio", score: Int.random(in: 140...150)),
        PlayerScore.init(name: "Benjamin", score: Int.random(in: 130...140)),
        PlayerScore.init(name: "Sophia", score: Int.random(in: 120...130)),
        PlayerScore.init(name: "Isabella", score: Int.random(in: 110...120)),
        PlayerScore.init(name: "James", score: Int.random(in: 100...110)),
        PlayerScore.init(name: "Oliver", score: Int.random(in: 90...100)),
        PlayerScore.init(name: "Mia", score: Int.random(in: 80...90)),
    ]
    
    private let bestScoreCoopArray : [PlayerScore] = [
        PlayerScore.init(name: "Elijah", score: Int.random(in: 140...150)),
        PlayerScore.init(name: "Amelia", score: Int.random(in: 130...140)),
        PlayerScore.init(name: "James", score: Int.random(in: 120...130)),
        PlayerScore.init(name: "Ava", score: Int.random(in: 110...120)),
        PlayerScore.init(name: "William", score: Int.random(in: 100...110)),
        PlayerScore.init(name: "Sophia", score: Int.random(in: 90...100)),
        PlayerScore.init(name: "Benjamin", score: Int.random(in: 80...90)),
    ]
    
    private lazy var bestScoreArrayDictionnary : [ String : [PlayerScore] ] = [
        gameModeStringArray[0] : bestScoreInfinityArray,
        gameModeStringArray[1] : bestScoreTimeArray,
        gameModeStringArray[2] : bestScoreCloseEnoughArray,
        gameModeStringArray[3] : bestScoreCoopArray,
    ]
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        self.view.addSubview(tableView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    @objc private func onQuitButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension LeaderboardsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bestScoreInfinityArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        guard let playerScore = bestScoreArrayDictionnary[gameModeStringArray[gameModeSelectedIndex]]?[indexPath.row] else {
            return cell
        }
        
        cell.score.text = String(playerScore.score)
        cell.name.text = playerScore.name
        
        return cell
    }
}

class CustomTableViewCell: UITableViewCell {
    let name = UILabel()
    let score = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        score.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(name)
        contentView.addSubview(score)
        
        NSLayoutConstraint.activate([
            name.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            name.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            
            score.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            score.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
