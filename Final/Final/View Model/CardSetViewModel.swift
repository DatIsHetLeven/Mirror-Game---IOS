//
//  CardSetViewModel.swift
//  Final
//
//  Created by Murat on 12/01/2024.
//

import Foundation
import SwiftUI

class CardSetViewModel: ObservableObject {
    // Toegevoegd voor CardSetsView
    @Published var cardSets: [CardSet] = []
    @Published var showingDeleteAlert = false
    @Published var selectedCardSetId: Int?
    
    // Toegevoegd voor CardSetDetailView
    @Published var cards: [Card] = []
    @Published var groupedCards: [Int: [Card]] = [:]
    @Published var selectedThemeId: Int? = nil
    
    

    func loadCardSets() {
        CardSetAPI.shared.fetchCardSets { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sets):
                    self?.cardSets = sets
                case .failure(let error):
                    print("Fout bij het laden van kaartensets: \(error)")
                }
            }
        }
    }

    func deleteCardSet(cardSetId: Int) {
        CardSetAPI.shared.deleteCardSet(cardSetId: cardSetId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Set succesvol verwijderd")
                    self?.loadCardSets() // Herlaad de kaartensets na het verwijderen
                case .failure(let error):
                    print("Fout bij het verwijderen van de set: \(error)")
                }
            }
        }
    }
    
    
    // Toegevoegd voor CardSetDetailView
       func loadCards(forCardSetId cardSetId: Int) {
           CardSetAPI.shared.fetchCards(forCardSetId: cardSetId) { [weak self] result in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let fetchedCards):
                       self?.cards = fetchedCards
                       self?.groupedCards = Dictionary(grouping: self?.cards ?? [], by: { $0.theme.id ?? 0 })
                   case .failure(let error):
                       print("Fout tijdens het ophalen van kaarten: \(error)")
                   }
               }
           }
       }

       func themeName(for themeId: Int) -> String {
           return cards.first(where: { $0.theme.id == themeId })?.theme.name ?? "Onbekend thema"
       }
   }
