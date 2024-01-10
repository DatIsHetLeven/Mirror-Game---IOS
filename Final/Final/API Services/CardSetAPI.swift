//
//  CardSetAPI.swift
//  Final
//
//  Created by Murat on 10/01/2024.
//

import Foundation

class CardSetAPI {
    static let shared = CardSetAPI()
    private let baseURL = "http://10.0.114.78:8080" // Pas dit aan naar jouw server's URL

    private init() {}

    func createDeck(name: String, description: String, completion: @escaping (Result<CardSetData, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/cardsets") else {
            completion(.failure(APIError.invalidURL))
            return
        }

        let deckData = ["name": name, "description": description]
        guard let uploadData = try? JSONEncoder().encode(deckData) else {
            completion(.failure(APIError.encodingError))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = uploadData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(CardSetResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse.data))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}


// Error handling
extension CardSetAPI {
    enum APIError: Error {
        case invalidURL
        case noData
        case encodingError
        case serverError
    }
}

//// Response Structs
//struct CardSetResponse: Codable {
//    var data: CardSetData
//}
//
//struct CardSetData: Codable {
//    var id: Int
//    // Voeg eventuele andere benodigde velden toe
//}

