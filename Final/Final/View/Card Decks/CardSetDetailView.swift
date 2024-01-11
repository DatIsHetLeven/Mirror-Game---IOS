////
////  CardSetDetailView.swift
////  Final
////
////  Created by Murat on 03/01/2024.
////
//

import SwiftUI

struct CardSetDetailView: View {
    var cardSetId: Int
    @State private var cards: [Card] = []
    @State private var groupedCards: [Int: [Card]] = [:]
    @State private var selectedThemeId: Int? = nil

    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        VStack {
            Text("Card Set Details")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(groupedCards.keys.sorted(), id: \.self) { themeId in
                            Button(action: {
                                selectedThemeId = selectedThemeId == themeId ? nil : themeId
                            }) {
                                VStack {
                                    Text(themeName(for: themeId))
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                                .frame(width: 120, height: 120)
                                .background(Color.blue)
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                
                if let selectedThemeId = selectedThemeId {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(Array(groupedCards[selectedThemeId]!.enumerated()), id: \.element.id) { index, card in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("#\(index + 1)")
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
                    .padding()
                }
            }
            .onAppear(perform: loadCards)
        }
    }

    func loadCards() {
        CardSetAPI.shared.fetchCards(forCardSetId: cardSetId) { result in
            switch result {
            case .success(let fetchedCards):
                self.cards = fetchedCards
                // Gebruik een standaardwaarde voor het geval dat `theme.id` nil is
                self.groupedCards = Dictionary(grouping: self.cards, by: { $0.theme.id ?? 0 })
            case .failure(let error):
                print("Fout tijdens het ophalen van kaarten: \(error)")
            }
        }
    }

    func themeName(for themeId: Int) -> String {
        return cards.first(where: { $0.theme.id == themeId })?.theme.name ?? "Onbekend thema"
    }
}
