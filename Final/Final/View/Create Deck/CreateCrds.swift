//
//  CreateCrds.swift
//  Final
//
//  Created by Murat on 06/01/2024.

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
//    @State private var cards: [Card] = []
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
//    func loadThemes() {
//        CardAPI.shared.fetchThemes { result in
//            switch result {
//            case .success(let fetchedThemes):
//                self.themes = fetchedThemes
//            case .failure(let error):
//                print("Fout tijdens het ophalen van thema's: \(error)")
//            }
//        }
//    }
//
//    func createCard() {
//        let newCardData = CardData(
//            themeId: selectedThemeId ?? 0,
//            cardSetId: cardSetId,
//            textQuestion: textQuestion,
//            logoUrl: logoUrl,
//            imageUrl: imageUrl,
//            isActive: isActive,
//            isPrivate: isPrivate
//        )
//
//        CardAPI.shared.createCard(cardData: newCardData) { result in
//            switch result {
//            case .success:
//                print("Kaart succesvol aangemaakt")
//                loadCards()
//            case .failure(let error):
//                print("Fout bij het aanmaken van de kaart: \(error)")
//            }
//        }
//    }
//
//    func loadCards() {
//        CardAPI.shared.fetchCards(forCardSetId: cardSetId) { result in
//            switch result {
//            case .success(let fetchedCards):
//                self.cards = fetchedCards
//            case .failure(let error):
//                print("Fout tijdens het ophalen van kaarten: \(error)")
//            }
//        }
//    }
//
//    func saveNewTheme() {
//        let uiColor = UIColor(newThemeColor)
//        let hexColor = uiColor.toHex()
//        let themeData = Theme(
//            name: newThemeName,
//            color: hexColor,
//            description: newThemeDescription,
//            fontType: newThemeFontType
//        )
//
//        CardAPI.shared.saveNewTheme(themeData: themeData) { result in
//            switch result {
//            case .success:
//                print("Thema succesvol opgeslagen")
//                loadThemes()
//            case .failure(let error):
//                print("Fout bij het opslaan van thema: \(error)")
//            }
//        }
//    }
//
//    var newThemeSection: some View {
//        Section(header: Text("Nieuw Thema")) {
//            TextField("Naam", text: $newThemeName)
//            ColorPicker("Kleur", selection: $newThemeColor)
//            TextField("Beschrijving", text: $newThemeDescription)
//            TextField("Font Type", text: $newThemeFontType)
//            Button("Opslaan") {
//                saveNewTheme()
//                showingNewThemeForm = false
//            }
//        }
//    }
//
//    struct CardSetResponse: Codable {
//        var data: CardSetData
//    }
//
//    struct CardSetData: Codable {
//        var id: Int
//    }
//
//}
//
//extension UIColor {
//    func toHex() -> String {
//        var r: CGFloat = 0
//        var g: CGFloat = 0
//        var b: CGFloat = 0
//        var a: CGFloat = 0
//
//        getRed(&r, green: &g, blue: &b, alpha: &a)
//        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
//        return String(format: "#%06x", rgb)
//    }
//}




import SwiftUI

struct CreateCards: View {
    var cardSetId: Int
    //@EnvironmentObject var viewModel: CreateDeckViewModel
    @ObservedObject var viewModel: CreateDeckViewModel
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Card Details")) {
                    TextField("Text Question", text: $viewModel.textQuestion)
                    TextField("Logo URL", text: $viewModel.logoUrl)
                    TextField("Image URL", text: $viewModel.imageUrl)
                    Toggle("Is Active", isOn: $viewModel.isActive)
                    Toggle("Is Private", isOn: $viewModel.isPrivate)

                    Picker("Select Theme", selection: $viewModel.selectedThemeId) {
                        ForEach(viewModel.themes, id: \.id) { theme in
                            Text(theme.name).tag(theme.id)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    Button("Voeg thema toe") {
                        viewModel.showingNewThemeForm = true
                        viewModel.selectedThemeId = nil
                    }

                    Button("Refresh") {
                        viewModel.loadThemes()
                    }
                }

                if !viewModel.textQuestion.isEmpty && !viewModel.logoUrl.isEmpty && !viewModel.imageUrl.isEmpty {
                    Section {
                        Button("Kaart aanmaken") {
                            viewModel.createCard()
                        }
                    }
                }

                if viewModel.showingNewThemeForm {
                    newThemeSection
                }
            }

            Section(header: Text("Opgeslagen Kaarten voor Set \(cardSetId)")) {
                List(viewModel.cards, id: \.id) { card in
                    VStack(alignment: .leading) {
                        Text(card.textQuestion)
                        Text("Thema ID: \(card.themeId)")
                    }
                }
            }

            Button("Refresh Kaarten") {
                viewModel.loadCards()
            }
        }
        .onAppear {
            viewModel.loadThemes()
            viewModel.loadCards()
        }
    }

    var newThemeSection: some View {
        Section(header: Text("Nieuw Thema")) {
            TextField("Naam", text: $viewModel.newThemeName)
            ColorPicker("Kleur", selection: $viewModel.newThemeColor)
            TextField("Beschrijving", text: $viewModel.newThemeDescription)
            TextField("Font Type", text: $viewModel.newThemeFontType)
            Button("Opslaan") {
                viewModel.saveNewTheme()
                viewModel.showingNewThemeForm = false
            }
        }
    }
}
