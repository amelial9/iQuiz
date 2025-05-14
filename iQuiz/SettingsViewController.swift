//
//  SettingsViewController.swift
//  iQuiz
//
//  Created by Amelia Li on 5/14/25.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {

    let instructionsLabel = UILabel()
    let urlField = UITextField()
    let checkButton = UIButton(type: .system)
    let statusLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        setupLayout()
    }

    func setupLayout() {
        instructionsLabel.text = "Delete the current URL and enter a new data source here!"
        instructionsLabel.font = .systemFont(ofSize: 16)
        instructionsLabel.textAlignment = .center
        instructionsLabel.numberOfLines = 0

        urlField.borderStyle = .roundedRect
        urlField.text = UserDefaults.standard.string(forKey: "dataURL") ?? "https://tednewardsandbox.site44.com/questions.json"
        urlField.autocapitalizationType = .none

        checkButton.setTitle("Check Now", for: .normal)
        checkButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        checkButton.addTarget(self, action: #selector(checkNow), for: .touchUpInside)

        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.textColor = .secondaryLabel
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [instructionsLabel, urlField, checkButton, statusLabel])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc func checkNow() {
        let url = urlField.text ?? ""
        UserDefaults.standard.setValue(url, forKey: "dataURL")
        statusLabel.text = "Checking..."

        NetworkManager.shared.fetchQuestions(from: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.statusLabel.text = "Fetched \(data.count) topic(s)."

                    var newTopics: [QuizTopic] = []
                    var newQuestions: [QuizQuestion] = []

                    for (index, dict) in data.enumerated() {
                        guard let title = dict["title"] as? String,
                              let desc = dict["desc"] as? String,
                              let questionsData = dict["questions"] as? [[String: Any]] else {
                            continue
                        }

                        let topicID = "topic\(index)"
                        let topic = QuizTopic(id: topicID, title: title, description: desc, imageName: "questionmark.circle")
                        newTopics.append(topic)

                        for qDict in questionsData {
                            guard let text = qDict["text"] as? String,
                                  let answerStr = qDict["answer"] as? String,
                                  let answers = qDict["answers"] as? [String],
                                  let index = Int(answerStr),
                                  index > 0 else {
                                continue
                            }

                            let correctIndex = index - 1

                            guard correctIndex < answers.count else {
                                continue
                            }

                            let question = QuizQuestion(topicID: topicID, text: text, options: answers, correctIndex: correctIndex)
                            newQuestions.append(question)
                        }
                    }

                    QuizDataStore.topics = newTopics
                    QuizDataStore.questions = newQuestions
                    NotificationCenter.default.post(name: Notification.Name("DidUpdateData"), object: nil)

                    self.dismiss(animated: true)

                case .failure(let error):
                    let alert = UIAlertController(
                        title: "Network Error",
                        message: "Could not load quiz data.\nReason: \(error.localizedDescription)",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
