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
        QuizQuestion(topicID: "math", text: "2 + 2 = ?", options: ["3", "4", "5"], correctIndex: 1),
        QuizQuestion(topicID: "math", text: "What is the square root of 9?", options: ["1", "2", "3"], correctIndex: 2),
        QuizQuestion(topicID: "math", text: "5 × 6 = ?", options: ["30", "25", "20"], correctIndex: 0),

        QuizQuestion(topicID: "marvel", text: "Who is Iron Man?", options: ["Tony Stark", "Bruce Banner", "Steve Rogers"], correctIndex: 0),
        QuizQuestion(topicID: "marvel", text: "Captain America's shield is made of?", options: ["Adamantium", "Vibranium", "Titanium"], correctIndex: 1),
        QuizQuestion(topicID: "marvel", text: "Thor is from which realm?", options: ["Asgard", "Midgard", "Jotunheim"], correctIndex: 0),

        QuizQuestion(topicID: "science", text: "H2O is the chemical formula for?", options: ["Oxygen", "Hydrogen", "Water"], correctIndex: 2),
        QuizQuestion(topicID: "science", text: "What planet is closest to the sun?", options: ["Mercury", "Venus", "Earth"], correctIndex: 0),
        QuizQuestion(topicID: "science", text: "Speed of light is?", options: ["3x10⁸ m/s", "1x10⁶ m/s", "9.8 m/s²"], correctIndex: 0)
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

        navigationController?.pushViewController(questionVC, animated: true)
    }
}
