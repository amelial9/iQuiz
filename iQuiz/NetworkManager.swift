//
//  NetworkManager.swift
//  iQuiz
//
//  Created by Amelia Li on 5/14/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let localFileName = "quizData.json"

    func fetchQuestions(from urlString: String, completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        if !NetworkMonitor.shared.isConnected {
            if let localData = self.loadFromLocal() {
                do {
                    let json = try JSONSerialization.jsonObject(with: localData, options: []) as? [[String: Any]]
                    completion(.success(json ?? []))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "Offline and no local file", code: -1)))
            }
            return
        }

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -10)))
            return
        }

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                self.saveToLocal(data: data)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    completion(.success(json ?? []))
                } catch {
                    completion(.failure(error))
                }

            } else if let localData = self.loadFromLocal() {
                do {
                    let json = try JSONSerialization.jsonObject(with: localData, options: []) as? [[String: Any]]
                    completion(.success(json ?? []))
                } catch {
                    completion(.failure(error))
                }

            } else {
                completion(.failure(error ?? NSError(domain: "No data and no local backup", code: -20)))
            }
        }

        task.resume()
    }

    private func saveToLocal(data: Data) {
        let url = getDocumentsDirectory().appendingPathComponent(localFileName)
        try? data.write(to: url)
        print("Saved quiz to: \(getDocumentsDirectory().appendingPathComponent("quizData.json").path)")
    }

    private func loadFromLocal() -> Data? {
        let url = getDocumentsDirectory().appendingPathComponent(localFileName)
        return try? Data(contentsOf: url)
    }

    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
