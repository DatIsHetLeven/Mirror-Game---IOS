//
//  CardAPI.swift
//  Final
//
//  Created by Murat on 10/01/2024.

//
import Foundation

class CardAPI {
    static let shared = CardAPI()
    
    private init() {}

    func fetchThemes(completion: @escaping (Result<[Theme], Error>) -> Void) {
        let endpoint = "\(APIManager.baseURL)/themes"
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
                let decodedResponse = try JSONDecoder().decode(ThemesResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse.data))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func createCard(cardData: CardData, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endpoint = "\(APIManager.baseURL)/cards"
        guard let url = URL(string: endpoint),
              let uploadData = try? JSONEncoder().encode(cardData) else {
            completion(.failure(APIError.invalidURL))
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

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(APIError.serverError))
                return
            }

            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }

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

    func saveNewTheme(themeData: Theme, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endpoint = "\(APIManager.baseURL)/themes"
        guard let url = URL(string: endpoint),
              let uploadData = try? JSONEncoder().encode(themeData) else {
            completion(.failure(APIError.invalidURL))
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

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(APIError.serverError))
                return
            }

            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }

    // API Fouten
    enum APIError: Error {
        case invalidURL
        case noData
        case serverError
    }
}


struct CardData: Codable {
    var themeId: Int
    var cardSetId: Int
    var textQuestion: String
    var logoUrl: String
    var imageUrl: String
    var isActive: Bool
    var isPrivate: Bool
}

// Structs voor API-responses
struct ThemesResponse: Codable {
    var data: [Theme]
}




