//
//  CreateCrds.swift
//  Final
//
//  Created by Murat on 06/01/2024.


//ddjdj
//
//import SwiftUI
//
//struct CreateCards: View {
//    var cardSetId: Int
//    //@EnvironmentObject var viewModel: CreateDeckViewModel
//    @ObservedObject var viewModel: CreateDeckViewModel
//    var body: some View {
//        VStack {
//            Form {
//                Section(header: Text("Card Details")) {
//                    TextField("Text Question", text: $viewModel.textQuestion)
//                    TextField("Logo URL", text: $viewModel.logoUrl)
//                    TextField("Image URL", text: $viewModel.imageUrl)
//                    Toggle("Is Active", isOn: $viewModel.isActive)
//                    Toggle("Is Private", isOn: $viewModel.isPrivate)
//
//                    Picker("Select Theme", selection: $viewModel.selectedThemeId) {
//                        ForEach(viewModel.themes, id: \.id) { theme in
//                            Text(theme.name).tag(theme.id)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//
//                    Button("Voeg thema toe") {
//                        viewModel.showingNewThemeForm = true
//                        viewModel.selectedThemeId = nil
//                    }
//
//                    Button("Refresh") {
//                        viewModel.loadThemes()
//                    }
//                }
//
//                if !viewModel.textQuestion.isEmpty && !viewModel.logoUrl.isEmpty && !viewModel.imageUrl.isEmpty {
//                    Section {
//                        Button("Kaart aanmaken") {
//                            viewModel.createCard()
//                        }
//                    }
//                }
//
//                if viewModel.showingNewThemeForm {
//                    newThemeSection
//                }
//            }
//
//            Section(header: Text("Opgeslagen Kaarten voor Set \(cardSetId)")) {
//                List(viewModel.cards, id: \.id) { card in
//                    VStack(alignment: .leading) {
//                        Text(card.textQuestion)
//                        Text("Thema ID: \(card.themeId)")
//                    }
//                }
//            }
//
//            Button("Refresh Kaarten") {
//                viewModel.loadCards()
//            }
//        }
//        .onAppear {
//            viewModel.loadThemes()
//            viewModel.loadCards()
//        }
//    }
//
//    var newThemeSection: some View {
//        Section(header: Text("Nieuw Thema")) {
//            TextField("Naam", text: $viewModel.newThemeName)
//            ColorPicker("Kleur", selection: $viewModel.newThemeColor)
//            TextField("Beschrijving", text: $viewModel.newThemeDescription)
//            TextField("Font Type", text: $viewModel.newThemeFontType)
//            Button("Opslaan") {
//                viewModel.saveNewTheme()
//                viewModel.showingNewThemeForm = false
//            }
//        }
//    }
//}







//
//
////deeze werkt
//import SwiftUI
//
//struct CreateCards: View {
//    var cardSetId: Int
//    @ObservedObject var viewModel: CreateDeckViewModel
//
//    @State private var showingThemeForm = false
//
//    var body: some View {
//        VStack {
//            HStack(spacing: 20) { // Splits het bovengedeelte horizontaal
//                // Linkerkant - Kaartenformulieren
//                VStack {
//                    Form {
//                        Section(header: Text("Card Details")) {
//                            TextField("Text Question", text: $viewModel.textQuestion)
//                                .padding()
//                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
//
//                            TextField("Logo URL", text: $viewModel.logoUrl)
//                                .padding()
//                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
//
//                            TextField("Image URL", text: $viewModel.imageUrl)
//                                .padding()
//                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
//
//                            Toggle("Is Active", isOn: $viewModel.isActive)
//
//                            Toggle("Is Private", isOn: $viewModel.isPrivate)
//
//                            Picker("Select Theme", selection: $viewModel.selectedThemeId) {
//                                ForEach(viewModel.themes, id: \.id) { theme in
//                                    Text(theme.name).tag(theme.id)
//                                }
//                            }
//                            .pickerStyle(MenuPickerStyle())
//
//                            Button("Voeg thema toe") {
//                                showingThemeForm.toggle()
//                                viewModel.selectedThemeId = nil
//                            }
//
//                            Button("Refresh") {
//                                viewModel.loadThemes()
//                            }
//                        }
//
//                        if !viewModel.textQuestion.isEmpty && !viewModel.logoUrl.isEmpty && !viewModel.imageUrl.isEmpty {
//                            Section {
//                                Button("Kaart aanmaken") {
//                                    viewModel.createCard()
//                                }
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.blue)
//                                .cornerRadius(10)
//                            }
//                        }
//                    }
//                }
//
//                // Rechterkant - Themaformulier
//                if showingThemeForm {
//                    newThemeSection
//                        .frame(maxWidth: .infinity)
//                        .transition(.move(edge: .trailing))
//                        .animation(.easeInOut)
//                }
//            }
//            .frame(maxWidth: .infinity)
//
//            Section(header: Text("Opgeslagen Kaarten voor Set \(cardSetId)")) {
//                List(viewModel.cards, id: \.id) { card in
//                    VStack(alignment: .leading) {
//                        Text(card.textQuestion)
//                        Text("Thema ID: \(card.themeId)")
//                    }
//                }
//            }
//
//            Button("Refresh Kaarten") {
//                viewModel.loadCards()
//            }
//            .font(.headline)
//            .foregroundColor(.white)
//            .frame(maxWidth: .infinity)
//            .padding()
//            .background(Color.blue)
//            .cornerRadius(10)
//        }
//        .onAppear {
//            viewModel.loadThemes()
//            viewModel.loadCards()
//        }
//        .padding()
//        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
//        .navigationBarTitle("Create Cards", displayMode: .inline)
//        .navigationBarItems(
//            trailing: Button(action: {
//                showingThemeForm.toggle()
//            }) {
//                Text(showingThemeForm ? "Sluit Thema Formulier" : "Thema Toevoegen")
//            }
//        )
//    }
//
//    var newThemeSection: some View {
//            Form {
//                TextField("Naam", text: $viewModel.newThemeName)
//                    .padding()
//                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
//
//                ColorPicker("Kleur", selection: $viewModel.newThemeColor)
//                    .padding()
//                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
//
//                TextField("Beschrijving", text: $viewModel.newThemeDescription)
//                    .padding()
//                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
//
//                TextField("Font Type", text: $viewModel.newThemeFontType)
//                    .padding()
//                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
//
//                Button("Opslaan") {
//                    viewModel.saveNewTheme()
//                    showingThemeForm.toggle()
//                }
//                .font(.headline)
//                .foregroundColor(.white)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.blue)
//                .cornerRadius(10)
//            }
//    }
//}
//
//




import SwiftUI

struct CreateCards: View {
    var cardSetId: Int
    @ObservedObject var viewModel: CreateDeckViewModel

    @State private var showingThemeForm = false

    var body: some View {
        VStack {
            HStack(spacing: 20) { // Splits het bovengedeelte horizontaal
                // Linkerkant - Kaartenformulieren
                VStack {
                    Form {
                        Section(header: Text("Card Details")) {
                            TextField("Text Question", text: $viewModel.textQuestion)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))

                            TextField("Logo URL", text: $viewModel.logoUrl)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))

                            TextField("Image URL", text: $viewModel.imageUrl)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))

                            Toggle("Is Active", isOn: $viewModel.isActive)

                            Toggle("Is Private", isOn: $viewModel.isPrivate)

                            Picker("Select Theme", selection: $viewModel.selectedThemeId) {
                                ForEach(viewModel.themes, id: \.id) { theme in
                                    Text(theme.name).tag(theme.id)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())

                            
                            Button("Voeg thema toe") {
                                showingThemeForm.toggle()
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
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                            }
                        }
                    }
                }

                // Rechterkant - Themaformulier
                if showingThemeForm {
                    newThemeSection
                        .frame(maxWidth: .infinity)
                        .transition(.move(edge: .trailing))
                        .animation(.easeInOut)
                }
            }
            .frame(maxWidth: .infinity)

            Section(header: Text("Opgeslagen Kaarten voor Set \(cardSetId)")) {
                List(viewModel.cards, id: \.id) { card in
                    VStack(alignment: .leading) {
                        Text(card.textQuestion)
                        Text("Thema: \(card.theme.name ?? "")") // Toon de thema-naam
                    }
                }
            }
            
            Button("Refresh Kaarten") {
                viewModel.loadCards()
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
        }
        .onAppear {
            viewModel.loadThemes()
            viewModel.loadCards()
        }
        .padding()
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .navigationBarTitle("Create Cards", displayMode: .inline)
        .navigationBarItems(
            trailing: Button(action: {
                showingThemeForm.toggle()
            }) {
                Text(showingThemeForm ? "Sluit Thema Formulier" : "Thema Toevoegen")
            }
        )
    }

    var newThemeSection: some View {
            Form {
                TextField("Naam", text: $viewModel.newThemeName)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))

                ColorPicker("Kleur", selection: $viewModel.newThemeColor)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))

                TextField("Beschrijving", text: $viewModel.newThemeDescription)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))

                TextField("Font Type", text: $viewModel.newThemeFontType)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))

                Button("Opslaan") {
                    viewModel.saveNewTheme()
                    showingThemeForm.toggle()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
    }
}





