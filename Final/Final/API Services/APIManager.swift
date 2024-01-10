//
//  APIManager.swift
//  Final
//
//  Created by Murat on 10/01/2024.
//


import Foundation

class APIManager {
    static let shared = APIManager()
    private let baseURL = "http://10.0.114.78:8080" // Pas dit aan naar jouw server's URL

    private init() {}

    // Ophalen van kaartensets
    func fetchCardSets(completion: @escaping (Result<[CardSet], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/cardsets") else {
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
        guard let url = URL(string: "\(baseURL)/cardsets/\(cardSetId)") else {
            completion(.failure(APIError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(APIError.serverError))
                return
            }

            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }

    // Ophalen van kaarten voor een specifieke kaartenset
    func fetchCards(forCardSetId cardSetId: Int, completion: @escaping (Result<[Card], Error>) -> Void) {
        let endpoint = "\(baseURL)/cards/cardsets/\(cardSetId)"
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

// API Fouten
enum APIError: Error {
    case invalidURL
    case noData
    case serverError
}



