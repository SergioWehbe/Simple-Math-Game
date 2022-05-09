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

final class GameViewController: UIViewController {
    
    var gameMode : GameMode = .time
    
    private var scoreLabel : UILabel!
    private var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    private var bestScoreLabel : UILabel!
    private var bestScore = 0 {
        didSet {
            bestScoreLabel.text = "Best: \(bestScore)"
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
    
    private var timer: Timer?
    private var timeFinishDate: Date = .now
    private var timeRemainingLabel : UILabel!
    private let timeRemainingInitial = 60
    
    private let bestScoreTimeModeString = "bestScoreTimeMode"
    private let bestScoreInfiniteModeString = "bestScoreInfiniteMode"
    
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
        
        bestScoreLabel = UILabel()
        bestScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        bestScoreLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(bestScoreLabel)
        
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
            
            bestScoreLabel.trailingAnchor.constraint(equalTo: scoreLabel.trailingAnchor),
            bestScoreLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
            
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
        
        if gameMode == .time {
            
            timeRemainingLabel = UILabel()
            timeRemainingLabel.translatesAutoresizingMaskIntoConstraints = false
            timeRemainingLabel.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .regular)
            view.addSubview(timeRemainingLabel)
            
            constraints.append(contentsOf: [
                timeRemainingLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -60),
                timeRemainingLabel.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor),
            ])
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerStep), userInfo: nil, repeats: true)
            timeFinishDate = .now.addingTimeInterval(60)
            timeRemainingLabel.text = "Time: 1 min"
        }
        
        NSLayoutConstraint.activate(constraints)
        
        score = 0
        
        switch gameMode {
        case .infinite:
            if let bestScore = UserDefaults.standard.object(forKey: bestScoreInfiniteModeString) as? Int {
                self.bestScore = bestScore
            }
        case .time:
            if let bestScore = UserDefaults.standard.object(forKey: bestScoreTimeModeString) as? Int {
                self.bestScore = bestScore
            }
            else {
                bestScore = 0
            }
        }
        
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
                    
                    UIView.animate(withDuration: 0.5) {
                        
                        self.tutorialLabel.text = "Choose the correct answer"
                        NSLayoutConstraint.deactivate(self.tutorialConstraintsEquation)
                        NSLayoutConstraint.activate(self.tutorialConstraintsAnswers)
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    @objc private func answerButtonTapped(_ sender: UIButton) {
        if sender.currentTitle == correctAnswer.toString {
            score += 1
            
            if let isTutorialDone = UserDefaults.standard.object(forKey: isTutorialDoneString) as? Bool,
               !isTutorialDone {
                
                UserDefaults.standard.set(true, forKey: isTutorialDoneString)
                tutorialLabel.removeFromSuperview()
                tutorialRectangle.removeFromSuperview()
            }
            
            if score > bestScore && gameMode == .infinite {
                UserDefaults.standard.set(score, forKey: bestScoreInfiniteModeString)
                bestScore = score
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
    
    @objc private func timerStep() {
        let timeRemaining = timeFinishDate.timeIntervalSinceNow
        if timeRemaining > 0 {
            setTimeRemainingLabelText(timeRemaining: timeRemaining)
        } else {
            timer?.invalidate()
            setTimeRemainingLabelText(timeRemaining: 0)
            
            for button in answerButtons {
                button.isEnabled = false
            }
            
            if score > bestScore {
                UserDefaults.standard.set(score, forKey: bestScoreTimeModeString)
                bestScore = score
            }
        }
    }
    
    private func setTimeRemainingLabelText(timeRemaining: Double) {
        timeRemainingLabel.text = "Time: \(round(timeRemaining).toString) s"
    }
    
    @objc private func onQuitButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    enum GameMode {
        case infinite
        case time
    }
    
    private enum MathOperation: CaseIterable {
        
        case addition
        case subtraction
        case multiplication
        case division
    }
}
