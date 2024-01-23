//
//  CreateCrds.swift
//  Final
//
//  Created by Murat on 06/01/2024.


import SwiftUI

struct CreateCards: View {
    var cardSetId: Int
    @ObservedObject var viewModel: CreateDeckViewModel

    @State private var showingThemeForm = false
    @State private var selectedThemeId: Int?

    var body: some View {
        VStack {
            HStack(spacing: 20) {
                // Linkerkant - Kaartenformulieren
                cardFormSection

                // Rechterkant - Themaformulier
                if showingThemeForm {
                    newThemeSection
                        .frame(maxWidth: .infinity)
                        .transition(.move(edge: .trailing))
                        .animation(.easeInOut)
                }
            }
            .frame(maxWidth: .infinity)

            // Sectie voor gegroepeerde thema's en kaarten
            groupedThemesSection
        }
        .onAppear {
            viewModel.loadThemes()
            viewModel.loadCards()
        }
        .padding()
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .navigationBarTitle("Kaart aanmaken", displayMode: .inline)
        .navigationBarItems(
            trailing: Button(action: {
                showingThemeForm.toggle()
            }) {
                Text(showingThemeForm ? "Sluit Thema Formulier" : "Thema Toevoegen")
            }
        )
    }

    var cardFormSection: some View {
        VStack {
            Form {
                Section(header: Text("Card Details")) {
                    TextField("Vraag", text: $viewModel.textQuestion)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))

                    Picker("Selecteer Thema", selection: $viewModel.selectedThemeId) {
                        if viewModel.selectedThemeId == nil {
                            Text("Kies").tag(nil as Int?) // Placeholder
                        }
                        ForEach(viewModel.themes, id: \.id) { theme in
                            Text(theme.name).tag(theme.id as Int?) // Aannemende dat theme.id een Int is
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

                if !viewModel.textQuestion.isEmpty {
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
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            // Voeg hier eventuele andere styling toe
                    }
                    if let Message = viewModel.Message {
                        Text(Message)
                            .foregroundColor(.green)
                            // Voeg hier eventuele andere styling toe
                    }

                }
            }
        }
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

//            TextField("Font Type", text: $viewModel.newThemeFontType)
//                .padding()
//                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))

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

    var themesScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.themes, id: \.id) { theme in
                    Button(action: {
                        withAnimation {
                            selectedThemeId = (selectedThemeId == theme.id) ? nil : theme.id
                        }
                    }) {
                        Text(theme.name)
                            .padding()
                            .background(selectedThemeId == theme.id ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    var groupedThemesSection: some View {
        VStack {
            HStack {
                // Horizontale ScrollView voor thema's
                ScrollView(.horizontal, showsIndicators: false) {
                    themesScrollView
                }

                // Refresh-knop
                Button(action: {
                    viewModel.loadCards()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .font(.title)
            }

            if let selectedId = selectedThemeId {
                let filteredCards = viewModel.cards.filter { $0.theme.id == selectedId }
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(Array(filteredCards.enumerated()), id: \.element.id) { index, card in
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
    }
}
