//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Amelia Li on 5/12/25.
//

import Foundation
import UIKit

class QuestionViewController: UIViewController {

    var quizManager: QuizManager!
    var buttons: [UIButton] = []
    var questionLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        showQuestion()
    }

    func setupLayout() {
        questionLabel.font = .systemFont(ofSize: 20, weight: .bold)
        questionLabel.numberOfLines = 0
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(questionLabel)

        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    func showQuestion() {
        guard let question = quizManager.currentQuestion else { return }

        questionLabel.text = question.text

        for b in buttons { b.removeFromSuperview() }
        buttons = []

        for (i, option) in question.options.enumerated() {
            let btn = UIButton(type: .system)
            btn.setTitle(option, for: .normal)
            btn.tag = i
            btn.addTarget(self, action: #selector(optionTapped(_:)), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(btn)
            buttons.append(btn)
        }

        for (i, btn) in buttons.enumerated() {
            NSLayoutConstraint.activate([
                btn.topAnchor.constraint(equalTo: i == 0 ? questionLabel.bottomAnchor : buttons[i - 1].bottomAnchor, constant: 20),
                btn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
    }

    @objc func optionTapped(_ sender: UIButton) {
        let isCorrect = quizManager.submit(answer: sender.tag)
        let answerVC = AnswerViewController()
        answerVC.quizManager = quizManager
        answerVC.wasCorrect = isCorrect
        navigationController?.pushViewController(answerVC, animated: true)
    }
}
