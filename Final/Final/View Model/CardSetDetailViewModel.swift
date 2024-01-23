//
//  CreateCardsViewModel.swift
//  Final
//
//  Created by Murat on 11/01/2024.
//

import SwiftUI

class CardSetDetailViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var groupedCards: [Int: [Card]] = [:]
    @Published var selectedThemeId: Int? = nil

    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    func loadCards(forCardSetId cardSetId: Int) {
        CardSetAPI.shared.fetchCards(forCardSetId: cardSetId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedCards):
                    self.cards = fetchedCards
                    self.groupedCards = Dictionary(grouping: self.cards, by: { $0.theme.id ?? 0 })
                case .failure(let error):
                    print("Error fetching cards: \(error)")
                }
            }
        }
    }

    func themeName(for themeId: Int) -> String {
        return cards.first(where: { $0.theme.id == themeId })?.theme.name ?? "Unknown Theme"
    }
    
    func themeColor(for themeId: Int) -> Color {
        return cards.first(where: { $0.theme.id == themeId })?.theme.colorValue ?? Color.gray
    }
}

