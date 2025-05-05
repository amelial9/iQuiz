//
//  ViewController.swift
//  iQuiz
//
//  Created by Amelia Li on 5/4/25.
//

import UIKit

class ViewController: UITableViewController {
    
    let topics = [
        QuizTopic(title: "Mathematics", description: "Test your math skills.", imageName: "function"),
        QuizTopic(title: "Marvel Super Heroes", description: "How well do you know the Marvel heroes?", imageName: "person.3.fill"),
        QuizTopic(title: "Science", description: "Explore science!", imageName: "atom")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QuizCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showSettings))
    }
    
    @objc func showSettings() {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let topic = topics[indexPath.row]
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "QuizCell")
        cell.textLabel?.text = String(topic.title.prefix(30))
        cell.detailTextLabel?.text = topic.description

        if let symbolImage = UIImage(systemName: topic.imageName) {
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
            cell.imageView?.image = symbolImage.withConfiguration(config)
        }

        cell.accessoryType = .disclosureIndicator
        return cell
    }

}
