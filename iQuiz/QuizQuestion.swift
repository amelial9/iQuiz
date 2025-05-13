//
//  QuizQuestion.swift
//  iQuiz
//
//  Created by Amelia Li on 5/12/25.
//

import Foundation

struct QuizQuestion: Identifiable {
    let id = UUID()
    let topicID: String
    let text: String
    let options: [String]
    let correctIndex: Int
}
