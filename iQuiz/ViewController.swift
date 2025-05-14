//
//  ViewController.swift
//  iQuiz
//
//  Created by Amelia Li on 5/4/25.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QuizCell")
        navigationItem.title = "Quiz Topics"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showSettings))

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)

    }

    @objc func showSettings() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .formSheet
        present(settingsVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QuizDataStore.topics.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let topic = QuizDataStore.topics[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "QuizCell")
        cell.textLabel?.text = topic.title
        cell.detailTextLabel?.text = topic.description

        if let symbolImage = UIImage(systemName: topic.imageName) {
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
            cell.imageView?.image = symbolImage.withConfiguration(config)
        }

        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTopic = QuizDataStore.topics[indexPath.row]
        let filteredQuestions = QuizDataStore.questions.filter { $0.topicID == selectedTopic.id }

        let manager = QuizManager(topic: selectedTopic, questions: filteredQuestions)
        let questionVC = QuestionViewController()
        questionVC.quizManager = manager

        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem

        navigationController?.pushViewController(questionVC, animated: true)
    }
    
    @objc func refreshData() {
        let url = UserDefaults.standard.string(forKey: "dataURL") ?? "https://tednewardsandbox.site44.com/questions.json"
        NetworkManager.shared.fetchQuestions(from: url) { result in
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                switch result {
                case .success(let data):
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
                                  let correctIndex = Int(answerStr),
                                  correctIndex >= 0,
                                  correctIndex < answers.count else {
                                continue
                            }

                            let question = QuizQuestion(topicID: topicID, text: text, options: answers, correctIndex: correctIndex)
                            newQuestions.append(question)
                        }
                    }
                    
                    QuizDataStore.topics = newTopics
                    QuizDataStore.questions = newQuestions
                    self.tableView.reloadData()
                    
                    self.tableView.reloadData()

                case .failure(let error):
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

}
