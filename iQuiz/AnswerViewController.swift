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
    }

    func setupLayout() {
        let resultLabel = UILabel()
        resultLabel.text = wasCorrect ? "✅ Correct!" : "❌ Incorrect"
        resultLabel.font = .systemFont(ofSize: 28, weight: .bold)
        resultLabel.textAlignment = .center
        resultLabel.translatesAutoresizingMaskIntoConstraints = false

        let nextButton = UIButton(type: .system)
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(resultLabel)
        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),

            nextButton.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 30),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
}
