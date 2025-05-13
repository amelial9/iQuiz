//
//  QuizManager.swift
//  iQuiz
//
//  Created by Amelia Li on 5/12/25.
//

import Foundation

class QuizManager {
    var topic: QuizTopic
    var questions: [QuizQuestion]
    var currentIndex = 0
    var score = 0

    init(topic: QuizTopic, questions: [QuizQuestion]) {
        self.topic = topic
        self.questions = questions
    }

    var currentQuestion: QuizQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    func submit(answer index: Int) -> Bool {
        let isCorrect = index == currentQuestion?.correctIndex
        if isCorrect { score += 1 }
        return isCorrect
    }

    func next() {
        currentIndex += 1
    }

    var isFinished: Bool {
        currentIndex >= questions.count - 1
    }

    func reset() {
        currentIndex = 0
        score = 0
    }
}
