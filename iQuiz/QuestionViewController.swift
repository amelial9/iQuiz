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
   var selectedAnswerIndex: Int? = nil
   var submitButton = UIButton(type: .system)

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
       questionLabel.font = .systemFont(ofSize: 20, weight: .bold)
       questionLabel.numberOfLines = 0
       questionLabel.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(questionLabel)

       submitButton.setTitle("Submit", for: .normal)
       submitButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
       submitButton.isEnabled = false
       submitButton.alpha = 0.5
       submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
       submitButton.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(submitButton)

       let hintLabel = UILabel()
       hintLabel.text = "← swipe to quit      swipe to submit →"
       hintLabel.font = .systemFont(ofSize: 14)
       hintLabel.textColor = .secondaryLabel
       hintLabel.textAlignment = .center
       hintLabel.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(hintLabel)

       NSLayoutConstraint.activate([
           questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
           questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
           questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

           submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
           submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

           hintLabel.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -12),
           hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
       ])
   }

   func showQuestion() {
       guard let question = quizManager.currentQuestion else { return }

       questionLabel.text = question.text

       for b in buttons { b.removeFromSuperview() }
       buttons = []
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
           btn.backgroundColor = .systemGray6
           btn.layer.cornerRadius = 8
           btn.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
           btn.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(btn)
           buttons.append(btn)
       }

       for (i, btn) in buttons.enumerated() {
           NSLayoutConstraint.activate([
               btn.topAnchor.constraint(equalTo: i == 0 ? questionLabel.bottomAnchor : buttons[i - 1].bottomAnchor, constant: 20),
               btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
               btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
               btn.heightAnchor.constraint(equalToConstant: 48)
           ])
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
