//
//  ViewController.swift
//  MathematicalOperationsGame
//
//  Created by Sergio Wehbe on 30/04/2022.
//

import UIKit

extension Double {
    var roundedToNearestHundredth: Double {
        return (self * 100).rounded() / 100
    }
    
    var toString: String {
        return trunc(self) == self ? String(Int(self)) : String(self)
    }
}

class GameViewController: UIViewController {
    
    private var scoreLabel : UILabel!
    private var mathOperationLabel : UILabel!
    private var operand1Label : UILabel!
    private var operand2Label : UILabel!
    
    private var answerButtons = [UIButton]()
    
    private var correctAnswer : Double = 0
    private var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(scoreLabel)
        
        mathOperationLabel = UILabel()
        mathOperationLabel.translatesAutoresizingMaskIntoConstraints = false
        mathOperationLabel.text = "+"
        view.addSubview(mathOperationLabel)
        
        operand1Label = UILabel()
        operand1Label.translatesAutoresizingMaskIntoConstraints = false
        operand1Label.text = "Number1"
        view.addSubview(operand1Label)
        
        operand2Label = UILabel()
        operand2Label.translatesAutoresizingMaskIntoConstraints = false
        operand2Label.text = "Number2"
        view.addSubview(operand2Label)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        let width = 100
        let height = 75
        // create 6 buttons as a 2x3 grid
        for row in 0..<2 {
            for col in 0..<3 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                letterButton.setTitle("2.5", for: .normal)
                letterButton.directionalLayoutMargins.leading = 100
                letterButton.directionalLayoutMargins.trailing = 100
                letterButton.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)

                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame

                buttonsView.addSubview(letterButton)

                answerButtons.append(letterButton)
            }
        }
        
        let constraints = [
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            mathOperationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mathOperationLabel.bottomAnchor.constraint(equalTo: buttonsView.topAnchor, constant: -75),
            
            operand1Label.trailingAnchor.constraint(equalTo: mathOperationLabel.leadingAnchor, constant: -20),
            operand1Label.topAnchor.constraint(equalTo: mathOperationLabel.topAnchor),
            
            operand2Label.leadingAnchor.constraint(equalTo: mathOperationLabel.trailingAnchor, constant: 20),
            operand2Label.topAnchor.constraint(equalTo: mathOperationLabel.topAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: CGFloat(3*width)),
            buttonsView.heightAnchor.constraint(equalToConstant: CGFloat(2*height)),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        score = 0
        nextRound()
    }
    
    @IBAction private func answerButtonTapped(_ sender: UIButton) {
        if sender.currentTitle == correctAnswer.toString {
            score += 1
        }
        else {
            score -= 1
        }
        nextRound()
    }
    
    private func nextRound() {
        
        let mathOperation = MathOperation.allCases.randomElement()!
        
        let operand1 = Int.random(in: 0...10)
        operand1Label.text = String(operand1)
        
        let operand2 = Int.random(in: mathOperation == .division ? 1...10 : 0...10)
        operand2Label.text = String(operand2)
        
        switch mathOperation {
        case .addition:
            mathOperationLabel.text = "+"
            correctAnswer = Double(operand1 + operand2)
            
        case .subtraction:
            mathOperationLabel.text = "-"
            correctAnswer = Double(operand1 - operand2)
            
        case .multiplication:
            mathOperationLabel.text = "*"
            correctAnswer = Double(operand1 * operand2)
            
        case .division:
            mathOperationLabel.text = "/"
            let correctAnswerBeforeRounding = Double(operand1) / Double(operand2)
            correctAnswer = correctAnswerBeforeRounding.roundedToNearestHundredth
        }
        
        
        let indexCorrectAnswer = Int.random(in: 0...5)
        answerButtons[indexCorrectAnswer].setTitle(correctAnswer.toString, for: .normal)
        
        for (index, button) in answerButtons.enumerated() {
            if index == indexCorrectAnswer {
                continue
            }
            
            var incorrectAnswer = correctAnswer
            
            switch mathOperation {
            case .division:
                if incorrectAnswer == 0 {
                    incorrectAnswer += Double(Int.random(in: 1...10))
                }
                else {
                    while incorrectAnswer == correctAnswer {
                        incorrectAnswer *= Double.random(in: 0.4...1.6)
                    }
                    incorrectAnswer = incorrectAnswer.roundedToNearestHundredth
                }

            default:
                while incorrectAnswer == correctAnswer {
                    incorrectAnswer += Double(Int.random(in: -10...10))
                }
            }
            
            button.setTitle(incorrectAnswer.toString, for: .normal)
        }
    }
    
    private enum MathOperation: CaseIterable {
        
        case addition
        case subtraction
        case multiplication
        case division
    }
}
