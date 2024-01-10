//
//  CreateDeck.swift
//  Final
//
//  Created by Murat on 05/01/2024.
//

import SwiftUI

struct CreateDeck: View {
    @State private var deckName: String = ""
    @State private var deckDescription: String = ""
    @State private var navigateToCreateCards = false
    @State private var generatedCardSetId: Int?


    var body: some View {
        VStack {
            // Stapindicator
            HStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 30, height: 30)
                    .overlay(Text("1"))
                Circle()
                    .fill(Color.gray)
                    .frame(width: 30, height: 30)
                    .overlay(Text("2"))
                Circle()
                    .fill(Color.gray)
                    .frame(width: 30, height: 30)
                    .overlay(Text("3"))
            }
            .padding()

            // Formulier
            Form {
                Section(header: Text("Deck Details")) {
                    TextField("Deck Name", text: $deckName)
                    TextField("Deck Description", text: $deckDescription)
                }
                Section {
                    Button("Volgende") {
                        createDeck()
                        // Logica voor 'Volgende' knop
                    }
                    .disabled(deckName.isEmpty || deckDescription.isEmpty) // Knop is uitgeschakeld als velden leeg zijn
                }
            }
            .navigationBarTitle("Create Deck", displayMode: .inline)

        }
        NavigationLink(destination: CreateCards(cardSetId: generatedCardSetId ?? 0), isActive: $navigateToCreateCards) {
            EmptyView()}
        }


        func createDeck() {
            guard let url = URL(string: "http://10.0.114.78:8080/cardsets") else { return }

            let deckData = ["name": deckName, "description": deckDescription]
            guard let uploadData = try? JSONEncoder().encode(deckData) else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = uploadData

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else { return }
                if let decodedResponse = try? JSONDecoder().decode(CardSetResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.generatedCardSetId = decodedResponse.data.id
                        self.navigateToCreateCards = true
                    }
                }
            }.resume()
        }

        struct CardSetResponse: Codable {
            var data: CardSetData
        }

        struct CardSetData: Codable {
            var id: Int
            // Voeg eventuele andere benodigde velden toe
        }

    }

