//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Amelia Li on 5/12/25.
//

import Foundation
import UIKit

class FinishedViewController: UIViewController {

    var quizManager: QuizManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
    }

    func setupLayout() {
        let scoreLabel = UILabel()
        scoreLabel.text = "You got \(quizManager.score) out of \(quizManager.questions.count) correct!"
        scoreLabel.font = .systemFont(ofSize: 24, weight: .bold)
        scoreLabel.numberOfLines = 0
        scoreLabel.textAlignment = .center
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false

        let feedbackLabel = UILabel()
        feedbackLabel.text = feedbackText()
        feedbackLabel.font = .systemFont(ofSize: 20)
        feedbackLabel.textAlignment = .center
        feedbackLabel.translatesAutoresizingMaskIntoConstraints = false

        let backButton = UIButton(type: .system)
        backButton.setTitle("Next", for: .normal)
        backButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        backButton.addTarget(self, action: #selector(backToTopics), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scoreLabel)
        view.addSubview(feedbackLabel)
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            feedbackLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 30),
            feedbackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            backButton.topAnchor.constraint(equalTo: feedbackLabel.bottomAnchor, constant: 40),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func feedbackText() -> String {
        let total = quizManager.questions.count
        switch quizManager.score {
        case total:
            return "🎉 Perfect!"
        case (total - 1):
            return "😄 Almost perfect!"
        default:
            return "💡 Keep practicing!"
        }
    }

    @objc func backToTopics() {
        navigationController?.popToRootViewController(animated: true)
    }
}
