//
//  ViewController.swift
//  iQuiz
//
//  Created by Amelia Li on 5/4/25.
//

import UIKit

class ViewController: UITableViewController {

    let topics: [QuizTopic] = [
        QuizTopic(id: "math", title: "Mathematics", description: "Test your math skills.", imageName: "function"),
        QuizTopic(id: "marvel", title: "Marvel Super Heroes", description: "How well do you know the Marvel heroes?", imageName: "person.3.fill"),
        QuizTopic(id: "science", title: "Science", description: "Explore science!", imageName: "atom")
    ]

    let questions: [QuizQuestion] = [
        QuizQuestion(topicID: "math", text: "10 - 4 = ?", options: ["5", "6", "7"], correctIndex: 1),
        QuizQuestion(topicID: "math", text: "What is 3 × 3?", options: ["6", "9", "12"], correctIndex: 1),
        QuizQuestion(topicID: "math", text: "Which is an even number?", options: ["3", "5", "8"], correctIndex: 2),

        QuizQuestion(topicID: "marvel", text: "Who is Iron Man?", options: ["Tony Stark", "Bruce Banner", "Steve Rogers"], correctIndex: 0),
        QuizQuestion(topicID: "marvel", text: "Loki is the God of what?", options: ["Fire", "Mischief", "Power"], correctIndex: 1),
        QuizQuestion(topicID: "marvel", text: "What does the TVA do in the Loki series?", options: ["Protect Asgard", "Fix timelines", "Train Avengers"], correctIndex: 1),
        QuizQuestion(topicID: "marvel", text: "What is Captain America's shield made of?", options: ["Vibranium", "Titanium", "Adamantium"], correctIndex: 0),

        QuizQuestion(topicID: "science", text: "The Earth revolves around the...?", options: ["Moon", "Sun", "Mars"], correctIndex: 1),
        QuizQuestion(topicID: "science", text: "Humans breathe in...?", options: ["Carbon dioxide", "Nitrogen", "Oxygen"], correctIndex: 2),
        QuizQuestion(topicID: "science", text: "Water boils at ___ °C?", options: ["50", "100", "200"], correctIndex: 1),

    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QuizCell")
        navigationItem.title = "Quiz Topics"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let topic = topics[indexPath.row]
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
        let selectedTopic = topics[indexPath.row]
        let filteredQuestions = questions.filter { $0.topicID == selectedTopic.id }

        let manager = QuizManager(topic: selectedTopic, questions: filteredQuestions)
        let questionVC = QuestionViewController()
        questionVC.quizManager = manager

        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem

        navigationController?.pushViewController(questionVC, animated: true)
    }

}
