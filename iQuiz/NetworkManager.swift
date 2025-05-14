//
//  NetworkManager.swift
//  iQuiz
//
//  Created by Amelia Li on 5/14/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    func fetchQuestions(from urlString: String, completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -2)))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                completion(.success(json ?? []))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

