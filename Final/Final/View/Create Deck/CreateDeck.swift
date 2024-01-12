//
//  CreateDeck.swift
//  Final
//
//  Created by Murat on 05/01/2024.



//import SwiftUI
//
//struct CreateDeck: View {
//    @State private var deckName: String = ""
//    @State private var deckDescription: String = ""
//    @State private var navigateToCreateCards = false
//    @State private var generatedCardSetId: Int?
//
//    var body: some View {
//        VStack {
//            HStack {
//                Circle()
//                    .fill(Color.green)
//                    .frame(width: 30, height: 30)
//                    .overlay(Text("1"))
//                Circle()
//                    .fill(Color.gray)
//                    .frame(width: 30, height: 30)
//                    .overlay(Text("2"))
//                Circle()
//                    .fill(Color.gray)
//                    .frame(width: 30, height: 30)
//                    .overlay(Text("3"))
//            }
//            .padding()
//
//            Form {
//                Section(header: Text("Deck Details")) {
//                    TextField("Deck Name", text: $deckName)
//                    TextField("Deck Description", text: $deckDescription)
//                }
//                Section {
//                    Button("Volgende") {
//                        createDeck()
//                    }
//                    .disabled(deckName.isEmpty || deckDescription.isEmpty)
//                }
//            }
//            .navigationBarTitle("Create Deck", displayMode: .inline)
//        }
//        // Deze navigatie wordt geactiveerd als generatedCardSetId wordt bijgewerkt
//        NavigationLink(destination: CreateCards(cardSetId: generatedCardSetId ?? 0), isActive: $navigateToCreateCards) {
//            EmptyView()
//        }
//    }
//
//
//    func createDeck() {
//        DeckAPI.shared.createDeck(name: deckName, description: deckDescription) { result in
//            switch result {
//            case .success(let cardSetId):
//                self.generatedCardSetId = cardSetId
//                self.navigateToCreateCards = true
//            case .failure(let error):
//                print("Fout bij het aanmaken van deck: \(error)")
//            }
//        }
//    }
//}


import SwiftUI

struct CreateDeck: View {
    @StateObject private var viewModel = CreateDeckViewModel()

    var body: some View {
        VStack {
            HStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 30, height: 30)
                    .overlay(Text("1"))
                Circle()
                    .fill(Color.gray)
                    .frame(width: 30, height: 30)
                    .overlay(Text("2"))
                Circle()
                    .fill(Color.gray)
                    .frame(width: 30, height: 30)
                    .overlay(Text("3"))
            }
            .padding()
            
            Form {
                Section(header: Text("Deck Details")) {
                    TextField("Deck Name", text: $viewModel.deckName)
                    TextField("Deck Description", text: $viewModel.deckDescription)
                }
                Section {
                    Button("Volgende") {
                        viewModel.createDeck()
                    }
                    .disabled(viewModel.deckName.isEmpty || viewModel.deckDescription.isEmpty)
                }
            }
            .navigationBarTitle("Create Deck", displayMode: .inline)
        }
//        NavigationLink(destination: CreateCards(cardSetId: viewModel.generatedCardSetId ?? 0), isActive: $viewModel.navigateToCreateCards) {
//            EmptyView()
//        }
        NavigationLink(destination: CreateCards(cardSetId: viewModel.generatedCardSetId ?? 0, viewModel: viewModel), isActive: $viewModel.navigateToCreateCards) {
            EmptyView()
        }

    }
}
