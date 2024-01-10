//
//  Card.swift
//  Final
//
//  Created by Murat on 03/01/2024.
//

//struct Card: Codable, Identifiable {
//    var id: Int
//    var themeId: Int
//    var cardSetId: Int
//    var textQuestion: String
//    var theme: Theme
//}


//Deel 2 is weer apart dit hoort niet bij hier biven
//struct Card: Codable, Identifiable {
//    var id: Int
//    var themeId: Int
//    var cardSetId: Int
//    var textQuestion: String
//    var logoUrl: String
//    var imageUrl: String
//    var isActive: Bool
//    var isPrivate: Bool
//    var dateCreated: String
//    var theme: Theme
//    var cardSet: CardSet
//}

struct Card: Codable, Identifiable {
    var id: Int
    var themeId: Int
    var cardSetId: Int
    var textQuestion: String
    var logoUrl: String
    var imageUrl: String
    var isActive: Bool
    var isPrivate: Bool
    var dateCreated: String
    var theme: Theme
    var cardSet: CardSet
}
// Response Structs voor kaarten
struct CardsResponse: Codable {
    var data: [Card]
}

//// Response Structs
//struct CardSetResponse: Codable {
//    var data: CardSetData
//}
//
struct CardSetData: Codable {
    var id: Int
    // Voeg eventuele andere benodigde velden toe
}


