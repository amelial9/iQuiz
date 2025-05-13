//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Amelia Li on 5/12/25.
//

import Foundation
import UIKit

class AnswerViewController: UIViewController {

    var quizManager: QuizManager!
    var wasCorrect: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        setupSwipeGestures()
        setupBackOverride()
    }

    func setupBackOverride() {
        navigationItem.hidesBackButton = true
        let customBack = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToRoot))
        navigationItem.leftBarButtonItem = customBack
    }

    @objc func backToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }

    func setupLayout() {
        guard let question = quizManager.currentQuestion else { return }

        let resultLabel = UILabel()
        resultLabel.text = wasCorrect ? "✅ Correct!" : "❌ Incorrect"
        resultLabel.font = .systemFont(ofSize: 28, weight: .bold)
        resultLabel.textAlignment = .center
        resultLabel.translatesAutoresizingMaskIntoConstraints = false

        let questionLabel = UILabel()
        questionLabel.text = "Q: \(question.text)"
        questionLabel.font = .systemFont(ofSize: 18, weight: .regular)
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .center
        questionLabel.translatesAutoresizingMaskIntoConstraints = false

        let answerLabel = UILabel()
        answerLabel.text = "Answer: \(question.options[question.correctIndex])"
        answerLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        answerLabel.textColor = .systemGreen
        answerLabel.textAlignment = .center
        answerLabel.translatesAutoresizingMaskIntoConstraints = false

        let nextButton = UIButton(type: .system)
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        let hintLabel = UILabel()
        hintLabel.text = "← swipe to quit      swipe to continue →"
        hintLabel.font = .systemFont(ofSize: 14)
        hintLabel.textColor = .secondaryLabel
        hintLabel.textAlignment = .center
        hintLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(resultLabel)
        view.addSubview(questionLabel)
        view.addSubview(answerLabel)
        view.addSubview(nextButton)
        view.addSubview(hintLabel)

        NSLayoutConstraint.activate([
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),

            questionLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            answerLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 10),
            answerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nextButton.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 30),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            hintLabel.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 20),
            hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func nextTapped() {
        if quizManager.isFinished {
            let finishedVC = FinishedViewController()
            finishedVC.quizManager = quizManager
            navigationController?.pushViewController(finishedVC, animated: true)
        } else {
            quizManager.next()
            let questionVC = QuestionViewController()
            questionVC.quizManager = quizManager
            navigationController?.pushViewController(questionVC, animated: true)
        }
    }

    func setupSwipeGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }

    @objc func handleSwipeRight() {
        nextTapped()
    }

    @objc func handleSwipeLeft() {
        let alert = UIAlertController(title: "Quit Quiz?", message: "Are you sure you want to abandon this quiz?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
