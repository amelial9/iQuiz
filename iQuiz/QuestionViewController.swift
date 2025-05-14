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
    var submitButton = UIButton(type: .system)
    var selectedAnswerIndex: Int? = nil
    var buttonStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        showQuestion()
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
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        questionLabel.font = .systemFont(ofSize: 20, weight: .bold)
        questionLabel.numberOfLines = 0
        questionLabel.translatesAutoresizingMaskIntoConstraints = false

        buttonStack.axis = .vertical
        buttonStack.spacing = 20
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.setContentHuggingPriority(.required, for: .vertical)

        submitButton.setTitle("Submit", for: .normal)
        submitButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        submitButton.isEnabled = false
        submitButton.alpha = 0.5
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false

        let hintLabel = UILabel()
        hintLabel.text = "← swipe to quit      swipe to submit →"
        hintLabel.font = .systemFont(ofSize: 14)
        hintLabel.textColor = .secondaryLabel
        hintLabel.textAlignment = .center
        hintLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(questionLabel)
        contentView.addSubview(buttonStack)
        contentView.addSubview(submitButton)
        contentView.addSubview(hintLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            buttonStack.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            buttonStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            buttonStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),

            submitButton.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 30),
            submitButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            hintLabel.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 12),
            hintLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            hintLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    func showQuestion() {
        guard let question = quizManager.currentQuestion else { return }

        questionLabel.text = question.text

        buttons.forEach { $0.removeFromSuperview() }
        buttons = []
        buttonStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        selectedAnswerIndex = nil
        submitButton.isEnabled = false
        submitButton.alpha = 0.5

        for (i, option) in question.options.enumerated() {
            let btn = UIButton(type: .system)
            btn.setTitle(option, for: .normal)
            btn.tag = i
            btn.contentHorizontalAlignment = .center
            btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            btn.titleLabel?.font = .systemFont(ofSize: 18)
            btn.titleLabel?.numberOfLines = 0 // Allow multiline text
            btn.backgroundColor = .systemGray6
            btn.layer.cornerRadius = 8
            btn.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
            buttonStack.addArrangedSubview(btn)
            buttons.append(btn)
        }
    }

    @objc func optionSelected(_ sender: UIButton) {
        selectedAnswerIndex = sender.tag
        submitButton.isEnabled = true
        submitButton.alpha = 1.0

        for (i, btn) in buttons.enumerated() {
            btn.backgroundColor = (i == sender.tag) ? .systemBlue.withAlphaComponent(0.2) : .systemGray6
        }
    }

    @objc func submitTapped() {
        guard let index = selectedAnswerIndex else { return }
        let isCorrect = quizManager.submit(answer: index)

        let answerVC = AnswerViewController()
        answerVC.quizManager = quizManager
        answerVC.wasCorrect = isCorrect
        navigationController?.pushViewController(answerVC, animated: true)
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
        if submitButton.isEnabled {
            submitTapped()
        } else {
            let alert = UIAlertController(title: "Select an Answer", message: "Choose an option before submitting.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
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
