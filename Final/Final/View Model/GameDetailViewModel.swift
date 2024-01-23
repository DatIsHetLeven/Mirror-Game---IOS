//
//  GameDetailViewModel.swift
//  Final
//
//  Created by Murat on 23/01/2024.
//

//import SwiftUI
//
//class GameDetailViewModel: ObservableObject {
//    @Published var cards: [Card] = []
//    @Published var groupedCards: [Int: [Card]] = [:]
//    @Published var selectedThemeId: Int? = nil
//    @Published var selectedQuestion: Card? = nil
//    @Published var answerText: String = ""
//    @Published var showUnsavedChangesAlert: Bool = false
//
//    func loadCards(forCardSetId selectedCardSetID: Int) {
//        CardSetAPI.shared.fetchCards(forCardSetId: selectedCardSetID) { result in
//            switch result {
//            case .success(let fetchedCards):
//                self.cards = fetchedCards
//                // Gebruik een standaardwaarde voor het geval dat `theme.id` nil is
//                self.groupedCards = Dictionary(grouping: self.cards, by: { $0.theme.id ?? 0 })
//            case .failure(let error):
//                print("Fout tijdens het ophalen van kaarten: \(error)")
//            }
//        }
//    }
//
//    func themeName(for themeId: Int) -> String {
//        return cards.first(where: { $0.theme.id == themeId })?.theme.name ?? "Onbekend thema"
//    }
//
//    func themeColor(for themeId: Int) -> Color {
//        return cards.first(where: { $0.theme.id == themeId })?.theme.colorValue ?? Color.gray // Fallback color
//    }
//
//    func sendAnswer(gameName: String, userName: String, answerGameId: Int) {
//        guard let url = URL(string: "http://localhost:8080/answers") else {
//            print("Invalid URL")
//            return
//        }
//
//        let answerData = AnswerData(
//            gameId: answerGameId,
//            gameName: gameName,
//            question: selectedQuestion?.textQuestion ?? "Unknown Question",
//            questionId: selectedQuestion?.id.description ?? "Unknown ID",
//            answerText: answerText,
//            dateAnswered: ISO8601DateFormatter().string(from: Date()),
//            writtenByUser: userName,
//            writtenByUserId: 203 // Pas dit aan op basis van je gebruikersinformatie
//        )
//
//        guard let encoded = try? JSONEncoder().encode(answerData) else {
//            print("Failed to encode answer")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        request.httpBody = encoded
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data {
//                if let response = try? JSONDecoder().decode(AnswerResponse.self, from: data) {
//                    // Verwerk het antwoord van de server hier
//                    print("Antwoord verzonden: \(response)")
//                    DispatchQueue.main.async {
//                        self.resetView()
//                    }
//                } else {
//                    print("Invalid response from server")
//                }
//            }
//            if let error = error {
//                print("HTTP Request Failed \(error)")
//            }
//        }.resume()
//    }
//
//    func resetView() {
//        answerText = ""
//        selectedQuestion = nil
//    }
//}












import Foundation // of andere relevante modules
import SwiftUI

class GameDetailViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var groupedCards: [Int: [Card]] = [:]
    @Published var selectedThemeId: Int? = nil
    @Published var selectedQuestion: Card? = nil
    @Published var answerText: String = ""
    @Published var showUnsavedChangesAlert: Bool = false

    private var selectedCardSetID: Int
    private var answerGameId: Int
    @Binding private var gameName: String
    @Binding private var userName: String

    init(selectedCardSetID: Int, answerGameId: Int, gameName: Binding<String>, userName: Binding<String>) {
        self.selectedCardSetID = selectedCardSetID
        self.answerGameId = answerGameId
        _gameName = gameName
        _userName = userName
    }

    func handleNavigation(themeId: Int) {
        if !answerText.isEmpty {
            showUnsavedChangesAlert = true
        } else {
            navigateToTheme(themeId: themeId)
        }
    }

    func navigateToTheme(themeId: Int) {
        selectedThemeId = selectedThemeId == themeId ? nil : themeId
        selectedQuestion = nil
    }

    func loadCards() {
        CardSetAPI.shared.fetchCards(forCardSetId: selectedCardSetID) { result in
            switch result {
            case .success(let fetchedCards):
                self.cards = fetchedCards
                self.groupedCards = Dictionary(grouping: self.cards, by: { $0.theme.id ?? 0 })
            case .failure(let error):
                print("Fout tijdens het ophalen van kaarten: \(error)")
            }
        }
    }

    func themeName(for themeId: Int) -> String {
        return cards.first(where: { $0.theme.id == themeId })?.theme.name ?? "Onbekend thema"
    }

    func themeColor(for themeId: Int) -> Color {
        return cards.first(where: { $0.theme.id == themeId })?.theme.colorValue ?? Color.gray
    }
    
    
    func sendAnswer() {
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
                        self.resetView()
                    }
                } else {
                    print("Invalid response from server")
                }
            }
            if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }.resume()
    }

//    func sendAnswer() {
//        PlayAPI.SaveAnswer.sendAnswer(gameName: gameName, userName: userName, answerGameId: answerGameId, selectedQuestion: selectedQuestion, answerText: answerText) { result in
//            switch result {
//            case .success(let response):
//                print("Antwoord verzonden: \(response)")
//                DispatchQueue.main.async {
//                    self.resetView()
//                }
//            case .failure(let error):
//                print("Error sending answer: \(error)")
//            }
//        }
//
//    }


    func resetView() {
        answerText = ""
        selectedQuestion = nil
    }
}
