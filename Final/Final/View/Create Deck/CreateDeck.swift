//
//  CreateDeck.swift
//  Final
//
//  Created by Murat on 05/01/2024.



//
//import SwiftUI
//
//struct CreateDeck: View {
//    @StateObject private var viewModel = CreateDeckViewModel()
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
//                    TextField("Deck Name", text: $viewModel.deckName)
//                    TextField("Deck Description", text: $viewModel.deckDescription)
//                }
//                Section {
//                    Button("Volgende") {
//                        viewModel.createDeck()
//                    }
//                    .disabled(viewModel.deckName.isEmpty || viewModel.deckDescription.isEmpty)
//                }
//            }
//            .navigationBarTitle("Create Deck", displayMode: .inline)
//        }
////        NavigationLink(destination: CreateCards(cardSetId: viewModel.generatedCardSetId ?? 0), isActive: $viewModel.navigateToCreateCards) {
////            EmptyView()
////        }
//        NavigationLink(destination: CreateCards(cardSetId: viewModel.generatedCardSetId ?? 0, viewModel: viewModel), isActive: $viewModel.navigateToCreateCards) {
//            EmptyView()
//        }
//
//    }
//}
//



//import SwiftUI
//
//struct CreateDeck: View {
//    @StateObject private var viewModel = CreateDeckViewModel()
//    @State private var navigateToCreateCards = false
//
//    var body: some View {
//        VStack {
//            HStack {
//                Circle()
//                    .fill(Color.green)
//                    .frame(width: 30, height: 30)
//                    .overlay(Text("1").foregroundColor(.white))
//                Circle()
//                    .fill(Color.gray)
//                    .frame(width: 30, height: 30)
//                    .overlay(Text("2").foregroundColor(.white))
//                Circle()
//                    .fill(Color.gray)
//                    .frame(width: 30, height: 30)
//                    .overlay(Text("3").foregroundColor(.white))
//            }
//            .padding()
//
//            Form {
//                Section(header: Text("Deck Details")) {
//                    TextField("Deck Name", text: $viewModel.deckName)
//                    TextField("Deck Description", text: $viewModel.deckDescription)
//                }
//
//                Section {
//                    Button("Volgende") {
//                        viewModel.createDeck()
//                        navigateToCreateCards = true
//                    }
//                    .disabled(viewModel.deckName.isEmpty || viewModel.deckDescription.isEmpty)
//                    .background(NavigationLink("", destination: CreateCards(cardSetId: viewModel.generatedCardSetId ?? 0, viewModel: viewModel), isActive: $navigateToCreateCards))
//                }
//            }
//            .navigationBarTitle("Create Deck", displayMode: .inline)
//        }
//    }
//}







//import SwiftUI
//
//struct CreateDeck: View {
//    @StateObject private var viewModel = CreateDeckViewModel()
//    @State private var isNextViewActive = false
//
//    var body: some View {
//        VStack {
//            HStack {
//                Circle()
//                    .fill(Color.green)
//                    .frame(width: 30, height: 30)
//                    .overlay(Text("1").foregroundColor(.white))
//                    .padding()
//                    .background(Circle().fill(Color.blue).frame(width: 40, height: 40))
//
//                Circle()
//                    .fill(Color.gray)
//                    .frame(width: 30, height: 30)
//                    .overlay(Text("2").foregroundColor(.white))
//                    .padding()
//                    .background(Circle().fill(Color.blue).frame(width: 40, height: 40))
//
//                Circle()
//                    .fill(Color.gray)
//                    .frame(width: 30, height: 30)
//                    .overlay(Text("3").foregroundColor(.white))
//                    .padding()
//                    .background(Circle().fill(Color.blue).frame(width: 40, height: 40))
//            }
//            .padding(.top, 20)
//
//            Form {
//                Section(header: Text("Deck Details")) {
//                    TextField("Deck Name", text: $viewModel.deckName)
//                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
//
//                    TextField("Deck Description", text: $viewModel.deckDescription)
//                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
//                }
//
//                Section {
//                    NavigationLink("", destination: CreateCards(cardSetId: viewModel.generatedCardSetId ?? 0, viewModel: viewModel), isActive: $isNextViewActive)
//                        .opacity(0)
//
//                    Button(action: {
//                        viewModel.createDeck()
//                        isNextViewActive = true
//                    }) {
//                        Text("Volgende")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.blue)
//                            .cornerRadius(10)
//                    }
//                    .disabled(viewModel.deckName.isEmpty || viewModel.deckDescription.isEmpty)
//                }
//            }
//            .listStyle(GroupedListStyle())
//            .navigationBarTitle("Create Deck", displayMode: .inline)
//        }
//        .onAppear {
//            // Hier kun je de waarde van viewModel.generatedCardSetId instellen op basis van je logica
//            // viewModel.generatedCardSetId = ...
//        }
//        .padding()
//        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
//    }
//}

















import SwiftUI

struct CreateDeck: View {
    @StateObject private var viewModel = CreateDeckViewModel()
    @State private var isNextViewActive = false

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "1.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.green)
                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                
                Image(systemName: "2.circle")
                    .font(.system(size: 30))
                    .foregroundColor(.gray)
                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                
                Image(systemName: "3.circle")
                    .font(.system(size: 30))
                    .foregroundColor(.gray)
                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
            }
            .padding(.top, 20)
            
            Form {
                Section(header: Text("Set Details").textCase(.none)) {
                    TextField("Set Naam", text: $viewModel.deckName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Omschrijving", text: $viewModel.deckDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section {
                    Button(action: {
                        viewModel.createDeck()
                        isNextViewActive = true
                    }) {
                        Text("Volgende")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.deckName.isEmpty || viewModel.deckDescription.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.deckName.isEmpty || viewModel.deckDescription.isEmpty)
                    // Hidden navigation link to trigger the next view
                    NavigationLink(destination: CreateCards(cardSetId: viewModel.generatedCardSetId ?? 0, viewModel: viewModel), isActive: $isNextViewActive) {
                        EmptyView()
                    }
                    .frame(width: 0, height: 0)
                    .opacity(0)
                }
            }
            .navigationBarTitle("Set Aanmaken", displayMode: .inline)
            
            // Tip (onderaand de pagina)
            Text("Tip: Geef je set een unieke naam om het snel terug te kunnen vinden.")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(.secondary)
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .padding(.horizontal)
    }
}

struct CreateDeck_Previews: PreviewProvider {
    static var previews: some View {
        CreateDeck()
    }
}
