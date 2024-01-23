//
//  PlayGame.swift
//  Final
//
//  Created by Murat on 22/01/2024.
//

import SwiftUI

struct PlayGame: View {
    @StateObject private var viewModel = CardSetViewModel()
    @ObservedObject private var reloadManager = ReloadManager()
    let spacing: CGFloat = 20
    @State private var searchText = ""
    @State private var selectedCardSet: CardSet?
    @State private var isStartButtonGreen = false
    @State private var isShowingForm = false
    @State private var gameName = ""
    @State private var userName = ""
    @State private var isStartButtonEnabled = false
    @State private var navigateToGameDetail = false

    var filteredCardSets: [CardSet] {
        if searchText.isEmpty {
            return viewModel.cardSets
        } else {
            return viewModel.cardSets.filter { cardSet in
                return cardSet.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    TextField("Zoeken", text: $searchText)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0))
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.leading, 10)
                        .frame(height: 40)
                    
                    Button(action: {
                        // viewModel.performSearch(text: searchText) 
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)

                ScrollView {
                    let availableWidth = geometry.size.width
                    let cardWidth = (availableWidth - (spacing * (3 + 1))) / 3
                    let cardHeight = cardWidth * 0.8

                    LazyVGrid(columns: [GridItem(.fixed(cardWidth)), GridItem(.fixed(cardWidth)), GridItem(.fixed(cardWidth))], spacing: spacing) {
                        ForEach(filteredCardSets, id: \.id) { cardSet in
                            cardView(
                                reloadManager: reloadManager,
                                cardSet: cardSet,
                                cardWidth: cardWidth,
                                cardHeight: cardHeight,
                                setid: cardSet.id
                            )
                            .onTapGesture {
                                selectedCardSet = cardSet
                                isStartButtonGreen = true
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedCardSet?.id == cardSet.id ? Color.black : Color.clear, lineWidth: 2)
                            )
                        }
                    }
                    .padding([.horizontal, .bottom], spacing)
                    .onAppear(perform: {
                        viewModel.loadCardSets()
                    })
                    .onReceive(reloadManager.$shouldReload, perform: { reload in
                        if reload {
                            viewModel.loadCardSets()
                            reloadManager.shouldReload = false
                        }
                    })
                }
            }
            .padding(.leading, geometry.safeAreaInsets.leading)
        }
        .navigationTitle("Speel")
        //.navigationBarTitle("Card Sets", displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                // Wanneer op de "Start" knop wordt gedrukt, toon het formulier
                isShowingForm = true
            }) {
                Text("Start")
                    .foregroundColor(isStartButtonGreen ? .green : .gray)
            }
            .disabled(selectedCardSet == nil)
        )
        .sheet(isPresented: $isShowingForm) {
            NavigationView {
                Form {
                    Section(header: Text("Spelgegevens")) {
                        TextField("Spelnaam", text: $gameName)
                        TextField("Gebruiker", text: $userName)
                    }

                    Button("Starten") {


                        // Sluit het formulier na het uitvoeren van de actie
                        isShowingForm = false

                        // Activeer de navigatie naar GameDetail en geef de cardSet-ID door
                        navigateToGameDetail = true
                    }
                    .disabled(gameName.isEmpty || userName.isEmpty) // Schakel de knop uit als een van de velden leeg is
                }
                .navigationBarTitle("Start", displayMode: .inline)
                .navigationBarItems(
                    leading: Button("Annuleren") {
                        // Sluit het formulier als de gebruiker op "Annuleren" drukt
                        isShowingForm = false
                    }
                )
            }
        }
        .background(
            NavigationLink(
                destination: GameDetail(gameName: $gameName, userName: $userName, selectedCardSetID: selectedCardSet?.id ?? 0, answerGameId: stringToInteger(gameName)),
                isActive: $navigateToGameDetail
            ) {
                EmptyView()
            }
        )
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func stringToInteger(_ inputString: String) -> Int {
            let lowercaseString = inputString.lowercased()
            let asciiOffset = 96
            var result = 0
            
            for character in lowercaseString {
                if let asciiValue = character.asciiValue {
                    let numericValue = Int(asciiValue) - asciiOffset
                    if numericValue >= 1 && numericValue <= 26 {
                        result += numericValue
                    }
                }
            }
            
            return result
        }
    
    
}














struct cardView: View {
    @State private var isEditing = false
    @State private var showingEditPopup = false
    @State private var showingDeleteAlert = false
    @ObservedObject var reloadManager: ReloadManager
    @StateObject private var viewModel = CardSetViewModel()
    @State private var alertMessage = ""
    @State private var showAlertMessage = false
    @State private var showAlert = false


    @State private var activeAlert: ActiveAlert = .deleteConfirmation

    
    enum ActiveAlert {
        case deleteConfirmation, showMessage
    }


    var cardSet: CardSet
    var cardWidth: CGFloat
    var cardHeight: CGFloat
    @State private var setid: Int // Voeg een @State-eigenschap toe om setid bij te houden

        init(reloadManager: ReloadManager, cardSet: CardSet, cardWidth: CGFloat, cardHeight: CGFloat, setid: Int) {
            self.reloadManager = reloadManager
            self.cardSet = cardSet
            self.cardWidth = cardWidth
            self.cardHeight = cardHeight
            _setid = State(initialValue: setid) // Initialiseer setid met de ontvangen waarde
        }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom))
                .frame(height: cardHeight / 2)

            Text(cardSet.name)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
                .padding([.top, .horizontal])

            Rectangle()
                .fill(Color.orange)
                .frame(height: 1)
                .padding(.horizontal)

            Text(cardSet.description)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding([.bottom, .horizontal])

            Spacer()

            HStack {
                Spacer()
                Button(action: {
                    activeAlert = .deleteConfirmation
                    showAlert = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .padding(.bottom, 8)
                .alert(isPresented: $showAlert) {
                    switch activeAlert {
                    case .deleteConfirmation:
                        return Alert(
                            title: Text("Verwijderen bevestigen"),
                            message: Text("U staat op het punt om de set \(cardSet.name) te verwijderen. Weet u zeker dat u dit wilt doen?"),
                            primaryButton: .destructive(Text("Ja, verwijder")) {
                                viewModel.deleteCardSet(cardSetId: cardSet.id) { result in
                                    switch result {
                                    case .success(let message):
                                        alertMessage = "Succes: \(message)"
                                        activeAlert = .showMessage
                                        showAlert = true
                                    case .failure(let message):
                                        alertMessage = "Fout: \(message)"
                                        activeAlert = .showMessage
                                        showAlert = true
                                    }
                                    reloadManager.shouldReload = true
                                }
                            },
                            secondaryButton: .cancel(Text("Annuleren"))
                        )
                    case .showMessage:
                        return Alert(
                            title: Text("Bericht"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }

            }
        }
        .frame(width: cardWidth, height: cardHeight)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}




