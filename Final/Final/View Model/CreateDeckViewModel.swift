//
//  CreateDeckViewModel.swift
//  Final
//
//  Created by Murat on 12/01/2024.
//

import Foundation
import SwiftUI

class CreateDeckViewModel: ObservableObject {
    // Bestaande eigenschappen voor het aanmaken van decks
    @Published var deckName: String = ""
    @Published var deckDescription: String = ""
    @Published var navigateToCreateCards = false
    @Published var generatedCardSetId: Int?
    
    // Eigenschappen specifiek voor CreateCards
    @Published var themes: [Theme] = []
    @Published var selectedThemeId: Int?
    @Published var showingNewThemeForm = false
    @Published var newThemeName: String = ""
    @Published var newThemeColor: Color = .blue
    @Published var newThemeDescription: String = ""
    @Published var newThemeFontType: String = "Arial"
    @Published var textQuestion: String = ""
    @Published var logoUrl: String = ""
    @Published var imageUrl: String = ""
    @Published var isActive: Bool = true
    @Published var isPrivate: Bool = false
    @Published var cards: [Card] = []
    
    //CreateDeck
    func createDeck() {
        DeckAPI.shared.createDeck(name: deckName, description: deckDescription) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cardSetId):
                    self?.generatedCardSetId = cardSetId
                    self?.navigateToCreateCards = true
                    print("creatdeck succes")
                case .failure(let error):
                    print("createdeck error")
                    print("Fout bij het aanmaken van deck: \(error)")
                }
            }
        }
    }
    
    
    // Methoden voor het aanmaken van kaarten -- createcards
    func loadThemes() {
        CardAPI.shared.fetchThemes { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedThemes):
                    self?.themes = fetchedThemes
                case .failure(let error):
                    print("Fout tijdens het ophalen van thema's: \(error)")
                }
            }
        }
    }
    
    func createCard() {
        let newCardData = CardData(
            themeId: selectedThemeId ?? 0,
            cardSetId: generatedCardSetId ?? 0,
            textQuestion: textQuestion,
            logoUrl: logoUrl,
            imageUrl: imageUrl,
            isActive: isActive,
            isPrivate: isPrivate
        )
        
        CardAPI.shared.createCard(cardData: newCardData) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Kaart succesvol aangemaakt")
                    self?.loadCards()
                case .failure(let error):
                    print("Fout bij het aanmaken van de kaart: \(error)")
                }
            }
        }
    }
    
    func loadCards() {
        guard let cardSetId = generatedCardSetId else { return }
        
        CardAPI.shared.fetchCards(forCardSetId: cardSetId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedCards):
                    self?.cards = fetchedCards
                case .failure(let error):
                    print("Fout tijdens het ophalen van kaarten: \(error)")
                }
            }
        }
    }
    
    
    func saveNewTheme() {
        // Converteer de SwiftUI Color naar een formaat dat opgeslagen kan worden (bijv. een hex string)
        let hexColor = newThemeColor.toHex()
        
        // Maak een nieuw thema object
        let newTheme = Theme(
            name: newThemeName,
            color: hexColor,
            description: newThemeDescription,
            fontType: newThemeFontType
        )
        
        // Sla het nieuwe thema op via een API of in een database
        CardAPI.shared.saveNewTheme(themeData: newTheme) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    // Als het thema succesvol is opgeslagen, laad dan de themalijst opnieuw
                    self?.loadThemes() // <- Hier is het gebruik van self? niet nodig
                    print("Thema succesvol opgeslagen")
                case .failure(let error):
                    print("Fout bij het opslaan van thema: \(error)")
                }
            }
        }
        
        
    }
}
