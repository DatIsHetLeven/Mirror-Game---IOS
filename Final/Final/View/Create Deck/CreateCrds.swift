////
////  CreateCrds.swift
////  Final
////
////  Created by Murat on 06/01/2024.
////
//
//
//import SwiftUI
//
//struct CreateCards: View {
//    var cardSetId: Int
//    @State private var themes: [Theme] = []
//    @State private var selectedThemeId: Int?
//
//    @State private var showingNewThemeForm = false
//    @State private var newThemeName: String = ""
//    @State private var newThemeColor: Color = .blue
//    @State private var newThemeDescription: String = ""
//    @State private var newThemeFontType: String = "Arial"
//
//    @State private var textQuestion: String = ""
//    @State private var logoUrl: String = ""
//    @State private var imageUrl: String = ""
//    @State private var isActive: Bool = true
//    @State private var isPrivate: Bool = false
//
//    @State private var cardsByTheme: [Int: [Card]] = [:]
//    @State private var cards: [Card] = []
//
//
//    var body: some View {
//        VStack {
//            Form {
//                Section(header: Text("Card Details")) {
//                    TextField("Text Question", text: $textQuestion)
//                    TextField("Logo URL", text: $logoUrl)
//                    TextField("Image URL", text: $imageUrl)
//                    Toggle("Is Active", isOn: $isActive)
//                    Toggle("Is Private", isOn: $isPrivate)
//
//                    Picker("Select Theme", selection: $selectedThemeId) {
//                        ForEach(themes, id: \.id) { theme in
//                            Text(theme.name).tag(theme.id)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//
//                    Button("Voeg thema toe") {
//                        showingNewThemeForm = true
//                        selectedThemeId = nil
//                    }
//
//                    Button("Refresh") {
//                        loadThemes()
//                    }
//                }
//
//                if !textQuestion.isEmpty && !logoUrl.isEmpty && !imageUrl.isEmpty {
//                    Section {
//                        Button("Kaart aanmaken") {
//                            createCard()
//                        }
//                    }
//                }
//
//                if showingNewThemeForm {
//                    newThemeSection
//                }
//            }
//
//            Section(header: Text("Opgeslagen Kaarten voor Set \(cardSetId)")) {
//                List(cards, id: \.id) { card in
//                    VStack(alignment: .leading) {
//                        Text(card.textQuestion)
//                        Text("Thema ID: \(card.themeId)")
//                        // Voeg hier eventueel meer details toe
//                    }
//                }
//            }
//
//            Button("Refresh Kaarten") {
//                loadCards()
//            }
//        }
//        .onAppear(perform: loadThemes)
//        .onAppear(perform: loadCards)
//    }
//
//
//    func loadCards() {
//        let urlString = "http://192.168.2.3:8080/cards/cardsets/\(cardSetId)"
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            DispatchQueue.main.async {
//                if let data = data {
//                    do {
//                        let decodedResponse = try JSONDecoder().decode(CardsResponse.self, from: data)
//                        self.cards = decodedResponse.data
//                        // Als je kaarten wilt groeperen op thema, gebruik dan de volgende regel:
//                        self.cardsByTheme = Dictionary(grouping: self.cards, by: { $0.theme.id ?? 0 })
//                    } catch {
//                        print("Decoderingsfout: \(error)")
//                    }
//                } else if let error = error {
//                    print("Fout tijdens het ophalen van data: \(error)")
//                }
//            }
//        }.resume()
//    }
//
//
//
//        var newThemeSection: some View {
//            Section(header: Text("Nieuw Thema")) {
//                TextField("Naam", text: $newThemeName)
//                ColorPicker("Kleur", selection: $newThemeColor)
//                TextField("Beschrijving", text: $newThemeDescription)
//                TextField("Font Type", text: $newThemeFontType)
//                Button("Opslaan") {
//                    saveNewTheme()
//                    showingNewThemeForm = false
//                }
//            }
//        }
//
//    private func groupCardsByTheme(_ cards: [Card]) {
//        cardsByTheme = Dictionary(grouping: cards, by: { $0.themeId })
//    }
//
//    func createCard() {
//        // Construct the card data object
//        let cardData = CardData(
//            themeId: selectedThemeId ?? 0,
//            cardSetId: cardSetId,
//            textQuestion: textQuestion,
//            logoUrl: logoUrl,
//            imageUrl: imageUrl,
//            isActive: isActive,
//            isPrivate: isPrivate
//        )
//
//        // Convert card data to JSON
//        guard let uploadData = try? JSONEncoder().encode(cardData) else {
//            print("Failed to encode card data")
//            return
//        }
//
//        // Define the URL for API call
//        guard let url = URL(string: "http://192.168.2.3:8080/cards") else {
//            print("Invalid URL")
//            return
//        }
//
//        // Create and configure the URLRequest
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = uploadData
//
//        // Perform the network request
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error creating card: \(error.localizedDescription)")
//                return
//            }
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                print("Card created successfully")
//                // Handle successful card creation here
//            } else {
//                print("Failed to create card")
//            }
//        }.resume()
//    }
//
//    // Define the struct for card data
//    struct CardData: Codable {
//        var themeId: Int
//        var cardSetId: Int
//        var textQuestion: String
//        var logoUrl: String
//        var imageUrl: String
//        var isActive: Bool
//        var isPrivate: Bool
//    }
//
//
//            func loadThemes() {
//                guard let url = URL(string: "http://192.168.2.3:8080/themes") else {
//                    print("Invalid URL")
//                    return
//                }
//
//                URLSession.shared.dataTask(with: url) { data, response, error in
//                    if let error = error {
//                        print("Error fetching themes: \(error.localizedDescription)")
//                        return
//                    }
//                    guard let data = data else {
//                        print("No data received")
//                        return
//                    }
//                    do {
//                        let decodedResponse = try JSONDecoder().decode(ThemesResponse.self, from: data)
//                        DispatchQueue.main.async {
//                            self.themes = decodedResponse.data
//                        }
//                    } catch {
//                        print("Decoding error: \(error.localizedDescription)")
//                    }
//                }.resume()
//            }
//
//    func saveNewTheme() {
//        let uiColor = UIColor(newThemeColor)
//        let hexColor = uiColor.toHex()
//        let themeData = Theme(name: newThemeName, color: hexColor, description: newThemeDescription, fontType: newThemeFontType)
//
//        guard let uploadData = try? JSONEncoder().encode(themeData) else {
//            print("Failed to encode theme data")
//            return
//        }
//
//        guard let url = URL(string: "http://192.168.2.3:8080/themes") else {
//            print("Invalid URL")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = uploadData
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error saving theme: \(error.localizedDescription)")
//                return
//            }
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                print("Theme saved successfully")
//                DispatchQueue.main.async {
//                    loadThemes() // Refresh themes
//                }
//            } else {
//                print("Failed to save theme")
//            }
//        }.resume()
//    }
//
//
//            // ... existing extensions and structs ...
//        }
//
//        struct ThemesResponse: Codable {
//            var data: [Theme]
//        }
//
//
//        extension UIColor {
//            func toHex() -> String {
//                var r: CGFloat = 0
//                var g: CGFloat = 0
//                var b: CGFloat = 0
//                var a: CGFloat = 0
//
//                getRed(&r, green: &g, blue: &b, alpha: &a)
//                let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
//                return String(format: "#%06x", rgb)
//            }
//        }
//
//





















import SwiftUI

struct CreateCards: View {
    var cardSetId: Int
    @State private var themes: [Theme] = []
    @State private var selectedThemeId: Int?
    
    @State private var showingNewThemeForm = false
    @State private var newThemeName: String = ""
    @State private var newThemeColor: Color = .blue
    @State private var newThemeDescription: String = ""
    @State private var newThemeFontType: String = "Arial"
    
    @State private var textQuestion: String = ""
    @State private var logoUrl: String = ""
    @State private var imageUrl: String = ""
    @State private var isActive: Bool = true
    @State private var isPrivate: Bool = false
    
    @State private var cards: [Card] = []
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Card Details")) {
                    TextField("Text Question", text: $textQuestion)
                    TextField("Logo URL", text: $logoUrl)
                    TextField("Image URL", text: $imageUrl)
                    Toggle("Is Active", isOn: $isActive)
                    Toggle("Is Private", isOn: $isPrivate)
                    
                    Picker("Select Theme", selection: $selectedThemeId) {
                        ForEach(themes, id: \.id) { theme in
                            Text(theme.name).tag(theme.id)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Button("Voeg thema toe") {
                        showingNewThemeForm = true
                        selectedThemeId = nil
                    }
                    
                    Button("Refresh") {
                        loadThemes()
                    }
                }
                
                if !textQuestion.isEmpty && !logoUrl.isEmpty && !imageUrl.isEmpty {
                    Section {
                        Button("Kaart aanmaken") {
                            createCard()
                        }
                    }
                }
                
                if showingNewThemeForm {
                    newThemeSection
                }
            }
            
            Section(header: Text("Opgeslagen Kaarten voor Set \(cardSetId)")) {
                List(cards, id: \.id) { card in
                    VStack(alignment: .leading) {
                        Text(card.textQuestion)
                        Text("Thema ID: \(card.themeId)")
                    }
                }
            }
            
            Button("Refresh Kaarten") {
                loadCards()
            }
        }
        .onAppear(perform: loadThemes)
        .onAppear(perform: loadCards)
    }
    
    func loadThemes() {
        CardAPI.shared.fetchThemes { result in
            switch result {
            case .success(let fetchedThemes):
                self.themes = fetchedThemes
            case .failure(let error):
                print("Fout tijdens het ophalen van thema's: \(error)")
            }
        }
    }
    
    func createCard() {
        let newCardData = CardData(
            themeId: selectedThemeId ?? 0,
            cardSetId: cardSetId,
            textQuestion: textQuestion,
            logoUrl: logoUrl,
            imageUrl: imageUrl,
            isActive: isActive,
            isPrivate: isPrivate
        )
        
        CardAPI.shared.createCard(cardData: newCardData) { result in
            switch result {
            case .success:
                print("Kaart succesvol aangemaakt")
                loadCards()
            case .failure(let error):
                print("Fout bij het aanmaken van de kaart: \(error)")
            }
        }
    }
    
    func loadCards() {
        CardAPI.shared.fetchCards(forCardSetId: cardSetId) { result in
            switch result {
            case .success(let fetchedCards):
                self.cards = fetchedCards
            case .failure(let error):
                print("Fout tijdens het ophalen van kaarten: \(error)")
            }
        }
    }
    
    func saveNewTheme() {
        let uiColor = UIColor(newThemeColor)
        let hexColor = uiColor.toHex()
        let themeData = Theme(
            name: newThemeName,
            color: hexColor,
            description: newThemeDescription,
            fontType: newThemeFontType
        )
        
        CardAPI.shared.saveNewTheme(themeData: themeData) { result in
            switch result {
            case .success:
                print("Thema succesvol opgeslagen")
                loadThemes()
            case .failure(let error):
                print("Fout bij het opslaan van thema: \(error)")
            }
        }
    }
    
    var newThemeSection: some View {
        Section(header: Text("Nieuw Thema")) {
            TextField("Naam", text: $newThemeName)
            ColorPicker("Kleur", selection: $newThemeColor)
            TextField("Beschrijving", text: $newThemeDescription)
            TextField("Font Type", text: $newThemeFontType)
            Button("Opslaan") {
                saveNewTheme()
                showingNewThemeForm = false
            }
        }
    }
    
    struct CardSetResponse: Codable {
        var data: CardSetData
    }
    
    struct CardSetData: Codable {
        var id: Int
        // Voeg eventuele andere benodigde velden toe
    }

}

extension UIColor {
    func toHex() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return String(format: "#%06x", rgb)
    }
}
