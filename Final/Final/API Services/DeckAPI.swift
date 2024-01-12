//
//  DeckAPI.swift
//  Final
//
//  Created by Murat on 10/01/2024.
//

import Foundation

class DeckAPI {
    static let shared = DeckAPI()
    
    private init() {}

    func createDeck(name: String, description: String, completion: @escaping (Result<Int, Error>) -> Void) {
        guard let url = URL(string: "\(APIManager.baseURL)/cardsets") else {
            completion(.failure(APIError.invalidURL))
            print("3")
            return
        }
        let deckData = ["name": name, "description": description]
        guard let uploadData = try? JSONEncoder().encode(deckData) else {
            completion(.failure(APIError.encodingError))
            print("4")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = uploadData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("5")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (httpResponse.statusCode == 200 || httpResponse.statusCode == 201),
                  let data = data else {
                completion(.failure(APIError.serverError))
                print("6")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(CardSetResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse.data.id))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

extension DeckAPI {
    enum APIError: Error {
        case invalidURL, noData, encodingError, serverError
    }

    struct CardSetResponse: Codable {
        var data: CardSetData
    }

    struct CardSetData: Codable {
        var id: Int
    }
}

