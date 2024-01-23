//
//  PlayAPI.swift
//  Final
//
//  Created by Murat on 23/01/2024.
//

import Foundation

class PlayAPI {
    static let shared = PlayAPI()
    
    struct SaveAnswer {
        static func sendAnswer(gameName: String, userName: String, answerGameId: Int, selectedQuestion: Card?, answerText: String, completion: @escaping (Result<AnswerResponse, Error>) -> Void) {
            guard let url = URL(string: "http://localhost:8080/answers") else {
                print("Invalid URL")
                return
            }

            let answerData = AnswerData(
                gameId: answerGameId,
                gameName: gameName,
                question: selectedQuestion?.textQuestion ?? "Unknown Question",
                questionId: selectedQuestion?.id.description ?? "Unknown ID",
                answerText: answerText,
                dateAnswered: ISO8601DateFormatter().string(from: Date()),
                writtenByUser: userName,
                writtenByUserId: 203
            )

            guard let encoded = try? JSONEncoder().encode(answerData) else {
                print("Failed to encode answer")
                return
            }

            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = encoded

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    if let response = try? JSONDecoder().decode(AnswerResponse.self, from: data) {
                        print("Antwoord verzonden: \(response)")
                        DispatchQueue.main.async {
                            completion(.success(response))
                        }
                    } else {
                        print("Invalid response from server")
                        completion(.failure(NSError(domain: "InvalidResponse", code: 1, userInfo: nil)))
                    }
                }
                if let error = error {
                    print("HTTP Request Failed \(error)")
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    
    
    
    
    
    
    

    func fetchCards(forCardSetId cardSetId: Int, completion: @escaping (Result<[Card], Error>) -> Void) {
        // Stel URL en URLRequest samen
        let url = URL(string: "https://example.com/api/cards/\(cardSetId)")!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            do {
                let cards = try JSONDecoder().decode([Card].self, from: data)
                completion(.success(cards))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

