//
//  CardSetAPI.swift
//  Final
//
//  Created by Murat on 10/01/2024.
//

import Foundation

class CardSetAPI {
    static let shared = CardSetAPI()
    
    private init() {}

    func createDeck(name: String, description: String, completion: @escaping (Result<CardSetData, Error>) -> Void) {
        guard let url = URL(string: "\(APIManager.baseURL)/cardsets") else {
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
    
    func fetchCardSets(completion: @escaping (Result<[CardSet], Error>) -> Void) {
        guard let url = URL(string: "\(APIManager.baseURL)/cardsets") else {
            completion(.failure(APIError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(CardSetsResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse.data))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // Verwijderen van een kaartenset
    func deleteCardSet(cardSetId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "\(APIManager.baseURL)/cardsets/\(cardSetId)") else {
            completion(.failure(APIError.invalidURL))
            print("1")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("2")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(APIError.serverError))
                print("3")
                return
            }

            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }

    // Ophalen van kaarten voor een specifieke kaartenset
    func fetchCards(forCardSetId cardSetId: Int, completion: @escaping (Result<[Card], Error>) -> Void) {
        let endpoint = "\(APIManager.baseURL)/cards/cardsets/\(cardSetId)"
        guard let url = URL(string: endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(CardsResponse.self, from: data)
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

