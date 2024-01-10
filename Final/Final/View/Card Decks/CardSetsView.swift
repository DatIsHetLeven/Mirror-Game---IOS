//
//  CardSetsView.swift
//  Final
//
//  Created by Murat on 03/01/2024.



import SwiftUI

struct CardSetsView: View {
    @State private var cardSets: [CardSet] = []
    @State private var showingDeleteAlert = false
    @State private var selectedCardSetId: Int?
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(cardSets, id: \.id) { cardSet in
                    NavigationLink(destination: CardSetDetailView(cardSetId: cardSet.id)) {
                        VStack(alignment: .leading) {
                            Text(cardSet.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(cardSet.description)
                                .font(.body)
                                .lineLimit(nil)

                            Spacer()

                            HStack {
                                Spacer()
                                Button(action: {
                                    self.selectedCardSetId = cardSet.id
                                    self.showingDeleteAlert = true
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding([.bottom, .trailing], 10)
                        }
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 150, idealHeight: 150, maxHeight: .infinity, alignment: .topLeading)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
            .onAppear(perform: loadCardSets)
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("Verwijderen bevestigen"),
                    message: Text("Weet je zeker dat je deze set wilt verwijderen?"),
                    primaryButton: .destructive(Text("Ja, verwijder")) {
                        if let cardSetId = selectedCardSetId {
                            deleteCardSet(cardSetId: cardSetId)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    func loadCardSets() {
        APIManager.shared.fetchCardSets { result in
            switch result {
            case .success(let sets):
                self.cardSets = sets
            case .failure(let error):
                print("Fout bij het laden van kaartensets: \(error)")
            }
        }
    }

    func deleteCardSet(cardSetId: Int) {
        APIManager.shared.deleteCardSet(cardSetId: cardSetId) { result in
            switch result {
            case .success:
                print("Set succesvol verwijderd")
                loadCardSets() // Herlaad de kaartensets na het verwijderen
            case .failure(let error):
                print("Fout bij het verwijderen van de set: \(error)")
            }
        }
    }
}
