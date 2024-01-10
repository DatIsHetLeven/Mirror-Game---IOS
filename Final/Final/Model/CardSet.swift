struct CardSet: Codable {
    let id: Int
    let name: String
    let description: String
}

struct CardSetsResponse: Codable {
    let success: Bool
    let message: String
    let statusCode: Int
    let data: [CardSet]
    let errors: [String]
}


// Response Structs
struct CardSetResponse: Codable {
    var data: CardSetData
}

//struct CardSet: Codable, Identifiable {
//    var id: Int
//    var name: String
//    var description: String
//}
