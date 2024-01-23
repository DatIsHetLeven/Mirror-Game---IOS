//
//  GameDetail.swift
//  Final
//
//  Created by Murat on 22/01/2024.
//

//
//import SwiftUI
//
//struct GameDetail: View {
//    @Binding var gameName: String
//    @Binding var userName: String
//    var selectedCardSetID: Int
//    var answerGameId: Int
//
//    @State private var cards: [Card] = []
//    @State private var groupedCards: [Int: [Card]] = [:]
//    @State private var selectedThemeId: Int? = nil
//    @State private var selectedQuestion: Card? = nil
//    @State private var answerText: String = ""
//    @State private var showUnsavedChangesAlert: Bool = false
//
//    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
//
//    var body: some View {
//        VStack {
//            Text("Game Detail")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .frame(maxWidth: .infinity, alignment: .center)
//
//            ScrollView {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack {
//                        ForEach(groupedCards.keys.sorted(), id: \.self) { themeId in
//                            Button(action: {
//                                handleNavigation(themeId: themeId)
//                            }) {
//                                VStack {
//                                    Text(themeName(for: themeId))
//                                        .font(.headline)
//                                        .foregroundColor(.white)
//                                }
//                                .frame(width: 120, height: 120)
//                                .background(themeColor(for: themeId))
//                                .cornerRadius(10)
//                            }
//                        }
//                    }
//                }
//
//                if let selectedThemeId = selectedThemeId {
//                    if let selectedQuestion = selectedQuestion {
//                        VStack(alignment: .leading) {
//                            Button(action: {
//                                handleNavigation(themeId: selectedThemeId)
//                            }) {
//                                Text(selectedQuestion.textQuestion)
//                                    .padding()
//                                    .frame(maxWidth: .infinity)
//                                    .background(Color.white)
//                                    .cornerRadius(10)
//                                    .shadow(radius: 5)
//                            }
//
//                            TextEditor(text: $answerText)
//                                .frame(minHeight: 200)
//                                .border(Color.gray, width: 1)
//                                .padding()
//
//                            Button(action: {
//                                sendAnswer()
//                            }) {
//                                Text("Opslaan")
//                                    .foregroundColor(.white)
//                                    .frame(maxWidth: .infinity)
//                                    .padding()
//                                    .background(Color.blue)
//                                    .cornerRadius(10)
//                            }
//                            .padding()
//                        }
//                    } else {
//                        LazyVGrid(columns: columns, spacing: 20) {
//                            ForEach(groupedCards[selectedThemeId] ?? [], id: \.id) { card in
//                                Button(action: {
//                                    self.selectedQuestion = card
//                                    self.answerText = "" // Reset het antwoordveld
//                                }) {
//                                    VStack(alignment: .leading) {
//                                        HStack {
//                                            Text("#\(card.id)")
//                                                .font(.caption)
//                                                .fontWeight(.bold)
//                                                .padding(5)
//                                                .background(Color.black)
//                                                .cornerRadius(10)
//                                                .foregroundColor(.white)
//                                            Spacer()
//                                        }
//                                        Text(card.textQuestion)
//                                            .padding()
//                                            .frame(maxWidth: .infinity)
//                                            .background(Color.white)
//                                            .cornerRadius(10)
//                                            .shadow(radius: 5)
//                                    }
//                                }
//                            }
//                        }
//                        .padding()
//                    }
//                }
//            }
//            .onAppear(perform: loadCards)
//        }
//        .padding()
//        .navigationBarTitle("Game Detail", displayMode: .inline)
//        // Alert voor onopgeslagen wijzigingen
//        .alert(isPresented: $showUnsavedChangesAlert) {
//            Alert(
//                title: Text("Onopgeslagen Wijzigingen"),
//                message: Text("Wil je de antwoorden opslaan?"),
//                primaryButton: .default(Text("Opslaan"), action: {
//                    sendAnswer()
//                    resetView()
//                }),
//                secondaryButton: .cancel(Text("Annuleren"))
//            )
//        }
//    }
//
//    func handleNavigation(themeId: Int) {
//        if !answerText.isEmpty {
//            showUnsavedChangesAlert = true
//        } else {
//            navigateToTheme(themeId: themeId)
//        }
//    }
//
//    func navigateToTheme(themeId: Int) {
//        selectedThemeId = selectedThemeId == themeId ? nil : themeId
//        selectedQuestion = nil
//    }
//
//    func loadCards() {
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
//    func sendAnswer() {
//            guard let url = URL(string: "http://localhost:8080/answers") else {
//                print("Invalid URL")
//                return
//            }
//
//            let answerData = AnswerData(
//                gameId: answerGameId,
//                gameName: gameName,
//                question: selectedQuestion?.textQuestion ?? "Unknown Question",
//                questionId: selectedQuestion?.id.description ?? "Unknown ID",
//                answerText: answerText,
//                dateAnswered: ISO8601DateFormatter().string(from: Date()),
//                writtenByUser: userName,
//                writtenByUserId: 203 // Pas dit aan op basis van je gebruikersinformatie
//            )
//
//            guard let encoded = try? JSONEncoder().encode(answerData) else {
//                print("Failed to encode answer")
//                return
//            }
//
//            var request = URLRequest(url: url)
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpMethod = "POST"
//            request.httpBody = encoded
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data {
//                if let response = try? JSONDecoder().decode(AnswerResponse.self, from: data) {
//                    // Verwerk het antwoord van de server hier
//                    print("Antwoord verzonden: \(response)")
//                    DispatchQueue.main.async {
//                        resetView()
//                    }
//                } else {
//                    print("Invalid response from server")
//                }
//            }
//            if let error = error {
//                print("HTTP Request Failed \(error)")
//            }
//        }.resume()
//        }
//    func resetView() {
//        answerText = ""
//        selectedQuestion = nil
//    }
//    }
//
//



























import SwiftUI

struct GameDetail: View {
    @Binding var gameName: String
    @Binding var userName: String
    var selectedCardSetID: Int
    var answerGameId: Int
    
    @State private var cards: [Card] = []
    @State private var groupedCards: [Int: [Card]] = [:]
    @State private var selectedThemeId: Int? = nil
    @State private var selectedQuestion: Card? = nil
    @State private var answerText: String = ""
    @State private var showUnsavedChangesAlert: Bool = false

    // Declare gameDetailViewModel without initializing it here
    @StateObject var gameDetailViewModel: GameDetailViewModel
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)


    init(gameName: Binding<String>, userName: Binding<String>, selectedCardSetID: Int, answerGameId: Int) {
        self._gameName = gameName
        self._userName = userName
        self.selectedCardSetID = selectedCardSetID
        self.answerGameId = answerGameId

        // Initialize gameDetailViewModel here with the necessary values
        self._gameDetailViewModel = StateObject(wrappedValue: GameDetailViewModel(selectedCardSetID: selectedCardSetID, answerGameId: answerGameId, gameName: gameName, userName: userName))
    }

    var body: some View {
        VStack {
            Text("Game Detail")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)

            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(gameDetailViewModel.groupedCards.keys.sorted(), id: \.self) { themeId in
                            Button(action: {
                                gameDetailViewModel.handleNavigation(themeId: themeId)
                            }) {
                                VStack {
                                    Text(gameDetailViewModel.themeName(for: themeId))
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                                .frame(width: 120, height: 120)
                                .background(gameDetailViewModel.themeColor(for: themeId))
                                .cornerRadius(10)
                            }
                        }
                    }
                }

                if let selectedThemeId = gameDetailViewModel.selectedThemeId {
                    if let selectedQuestion = gameDetailViewModel.selectedQuestion {
                        VStack(alignment: .leading) {
                            Button(action: {
                                gameDetailViewModel.handleNavigation(themeId: selectedThemeId)
                            }) {
                                Text(selectedQuestion.textQuestion)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }

                            TextEditor(text: $gameDetailViewModel.answerText)
                                .frame(minHeight: 200)
                                .border(Color.gray, width: 1)
                                .padding()

                            Button(action: {
                                gameDetailViewModel.sendAnswer()
                            }) {
                                Text("Opslaan")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                    } else {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(gameDetailViewModel.groupedCards[selectedThemeId] ?? [], id: \.id) { card in
                                Button(action: {
                                    gameDetailViewModel.selectedQuestion = card
                                    gameDetailViewModel.answerText = "" // Reset het antwoordveld
                                }) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("#\(card.id)")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .padding(5)
                                                .background(Color.black)
                                                .cornerRadius(10)
                                                .foregroundColor(.white)
                                            Spacer()
                                        }
                                        Text(card.textQuestion)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .onAppear(perform: gameDetailViewModel.loadCards)
        }
        .padding()
        .navigationBarTitle("Game Detail", displayMode: .inline)
        .alert(isPresented: $gameDetailViewModel.showUnsavedChangesAlert) {
            Alert(
                title: Text("Onopgeslagen Wijzigingen"),
                message: Text("Wil je de antwoorden opslaan?"),
                primaryButton: .default(Text("Opslaan"), action: {
                    gameDetailViewModel.sendAnswer()
                    gameDetailViewModel.resetView()
                }),
                secondaryButton: .cancel(Text("Annuleren"))
            )
        }
    }
}
