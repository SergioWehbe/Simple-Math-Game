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
    private var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    private var mathOperationLabel : UILabel!
    private var operand1Label : UILabel!
    private var operand2Label : UILabel!
    
    private var answerButtons = [UIButton]()
    
    private var tutorialLabel : UILabel!
    private var tutorialRectangle: UIView!
    private var tutorialConstraintsEquation = [NSLayoutConstraint]()
    private var tutorialConstraintsAnswers = [NSLayoutConstraint]()
    private var isTutorialDone = false
    private let isTutorialDoneString = "isTutorialDone"
    
    private var correctAnswer : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let quitButton = UIButton(type: .system)
        quitButton.translatesAutoresizingMaskIntoConstraints = false
        quitButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        quitButton.setTitle("Quit", for: .normal)
        quitButton.addTarget(self, action: #selector(onQuitButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(quitButton)
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(scoreLabel)
        
        mathOperationLabel = UILabel()
        mathOperationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mathOperationLabel)
        
        operand1Label = UILabel()
        operand1Label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(operand1Label)
        
        operand2Label = UILabel()
        operand2Label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(operand2Label)
        
        let answerButtonsView = UIView()
        answerButtonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(answerButtonsView)
        
        let answerButtonsRowCount = 2
        let answerButtonsColumnCount = 3
        let answerButtonWidth = 100
        let answerButtonHeight = 75
        
        for row in 0..<answerButtonsRowCount {
            for column in 0..<answerButtonsColumnCount {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                letterButton.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)

                let frame = CGRect(x: column * answerButtonWidth, y: row * answerButtonHeight, width: answerButtonWidth, height: answerButtonHeight)
                letterButton.frame = frame

                answerButtonsView.addSubview(letterButton)

                answerButtons.append(letterButton)
            }
        }
        
        let paddingFromScreenEdge: CGFloat = 10
        let paddingAroundMathOperation: CGFloat = 20
        let paddingBetweenMathOperationAndAnswerButtonsView: CGFloat = 75
        let paddingBetweenAnswerButtonsViewAndScreenBottom: CGFloat = 50
        
        var constraints = [
            quitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: paddingFromScreenEdge),
            quitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: paddingFromScreenEdge),
            
            scoreLabel.centerYAnchor.constraint(equalTo: quitButton.centerYAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -paddingFromScreenEdge),
            
            mathOperationLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            mathOperationLabel.bottomAnchor.constraint(equalTo: answerButtonsView.topAnchor, constant: -paddingBetweenMathOperationAndAnswerButtonsView),
            
            operand1Label.trailingAnchor.constraint(equalTo: mathOperationLabel.leadingAnchor, constant: -paddingAroundMathOperation),
            operand1Label.topAnchor.constraint(equalTo: mathOperationLabel.topAnchor),
            
            operand2Label.leadingAnchor.constraint(equalTo: mathOperationLabel.trailingAnchor, constant: paddingAroundMathOperation),
            operand2Label.topAnchor.constraint(equalTo: mathOperationLabel.topAnchor),
            
            answerButtonsView.widthAnchor.constraint(equalToConstant: CGFloat(answerButtonsColumnCount * answerButtonWidth)),
            answerButtonsView.heightAnchor.constraint(equalToConstant: CGFloat(answerButtonsRowCount * answerButtonHeight)),
            answerButtonsView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            answerButtonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -paddingBetweenAnswerButtonsViewAndScreenBottom),
        ]
        
        if UserDefaults.standard.object(forKey: isTutorialDoneString) == nil {
            UserDefaults.standard.set(false, forKey: isTutorialDoneString)
        }
        if let isTutorialDone = UserDefaults.standard.object(forKey: isTutorialDoneString) as? Bool {
            
            self.isTutorialDone = isTutorialDone
            
            if !isTutorialDone {
                
                let tutorialColor = CGColor(red: 0, green: 0.8, blue: 0, alpha: 1)
                
                tutorialLabel = UILabel()
                tutorialLabel.translatesAutoresizingMaskIntoConstraints = false
                tutorialLabel.text = "Calculate the answer"
                tutorialLabel.textColor = UIColor(cgColor: tutorialColor)
                tutorialLabel.alpha = 0
                view.addSubview(tutorialLabel)
                view.sendSubviewToBack(tutorialLabel)
                
                tutorialRectangle = UIView()
                tutorialRectangle.translatesAutoresizingMaskIntoConstraints = false
                tutorialRectangle.layer.borderWidth = 2
                tutorialRectangle.layer.borderColor = tutorialColor
                tutorialRectangle.alpha = 0
                view.addSubview(tutorialRectangle)
                view.sendSubviewToBack(tutorialRectangle)
                
                tutorialConstraintsEquation = [
                    tutorialRectangle.topAnchor.constraint(equalTo: mathOperationLabel.topAnchor, constant: -20),
                    tutorialRectangle.bottomAnchor.constraint(equalTo: mathOperationLabel.bottomAnchor, constant: 20),
                    tutorialRectangle.leadingAnchor.constraint(equalTo: operand1Label.leadingAnchor, constant: -20),
                    tutorialRectangle.trailingAnchor.constraint(equalTo: operand2Label.trailingAnchor, constant: 20),
                ]
                
                tutorialConstraintsAnswers = [
                    tutorialRectangle.topAnchor.constraint(equalTo: answerButtonsView.topAnchor),
                    tutorialRectangle.bottomAnchor.constraint(equalTo: answerButtonsView.bottomAnchor),
                    tutorialRectangle.leadingAnchor.constraint(equalTo: answerButtonsView.leadingAnchor),
                    tutorialRectangle.trailingAnchor.constraint(equalTo: answerButtonsView.trailingAnchor),
                ]
                
                constraints.append(contentsOf: [
                    tutorialLabel.centerXAnchor.constraint(equalTo: tutorialRectangle.centerXAnchor),
                    tutorialLabel.bottomAnchor.constraint(equalTo: tutorialRectangle.topAnchor, constant: -20),
                ])
                
                constraints.append(contentsOf: tutorialConstraintsEquation)
            }
        }
        
        NSLayoutConstraint.activate(constraints)
        
        score = 0
        nextRound()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isTutorialDone {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.animate(withDuration: 0.5) {
                    self.tutorialLabel.alpha = 1
                    self.tutorialRectangle.alpha = 1
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.tutorialLabel.alpha = 0
                    self.tutorialRectangle.alpha = 0
                    UIView.animate(withDuration: 0.5) {
                        self.tutorialLabel.alpha = 1
                        self.tutorialRectangle.alpha = 1
                        self.tutorialLabel.text = "Choose the correct answer"
                        NSLayoutConstraint.deactivate(self.tutorialConstraintsEquation)
                        NSLayoutConstraint.activate(self.tutorialConstraintsAnswers)
                    }
                }
            }
        }
    }
    
    @IBAction private func answerButtonTapped(_ sender: UIButton) {
        if sender.currentTitle == correctAnswer.toString {
            score += 1
            
            if let isTutorialDone = UserDefaults.standard.object(forKey: isTutorialDoneString) as? Bool,
               !isTutorialDone {
                
                UserDefaults.standard.set(true, forKey: isTutorialDoneString)
                tutorialLabel.removeFromSuperview()
                tutorialRectangle.removeFromSuperview()
            }
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
        
        
        let indexCorrectAnswer = Int.random(in: 0...answerButtons.count-1)
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
                    while abs(incorrectAnswer - correctAnswer) < 0.03 {
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
    
    @IBAction private func onQuitButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    private enum MathOperation: CaseIterable {
        
        case addition
        case subtraction
        case multiplication
        case division
    }
}
