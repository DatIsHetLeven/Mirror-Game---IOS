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
    
    
    func updateCardSet(cardSetId: Int, name: String, description: String) {
        CardSetAPI.shared.updateCardSet(cardSetId: cardSetId, name: name, description: description) { [weak self] result in
            guard let self = self else {
                return // Voorkom dat self optioneel is
            }
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Card set updated successfully")
                    // Voer hier verdere acties uit na een succesvolle update
                case .failure(let error):
                    print("Fout bij het bijwerken van de kaartenset: \(error)")
                    // Behandel de fout als dat nodig is
                }
            }
        }
    }

    
    
    
   }

//func updateCardSet(cardSetId: Int, name: String, description: String) {
//    let urlString = "http://192.168.2.3:8080/themes/\(cardSetId)"
//
//    guard let url = URL(string: urlString) else {
//        // Handle an invalid URL if necessary
//        return
//    }
//
//    let cardSetData: [String: Any] = [
//        "name": name,
//        "description": description
//    ]
//
//    let jsonData = try? JSONSerialization.data(withJSONObject: cardSetData)
//
//    var request = URLRequest(url: url)
//    request.httpMethod = "PUT"
//    request.httpBody = jsonData
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//    URLSession.shared.dataTask(with: request) { data, response, error in
//        if let error = error {
//            // Handle the error if necessary
//            print("Error: \(error.localizedDescription)")
//            return
//        }
//
//        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//            // Successful update, handle the response if needed
//            print("Card set updated successfully")
//        }
//    }.resume()
//}



