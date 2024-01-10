import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            SideMenu()
            HomeView()
        }
    }
}

struct HomeView: View {
    var body: some View {
        Text("Home Page")
            .navigationBarTitle("", displayMode: .large)
    }
}

struct SideMenu: View {
    var body: some View {
        List {
            NavigationLink(destination: HomeView()) {
                Label("Home", systemImage: "house")
            }
            NavigationLink(destination: CreateDeck()) {
                Label("Create Deck", systemImage: "plus.rectangle.on.rectangle")
            }
            NavigationLink(destination: Text("Play Game View")) {
                Label("Play Game", systemImage: "gamecontroller")
            }
            NavigationLink(destination: CardSetsView()) {
                Label("Card Decks", systemImage: "cards")
            }
            NavigationLink(destination: Text("Archive View")) {
                Label("Archive", systemImage: "tray.full")
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Menu")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: "person.crop.circle")
            }
        }
    }
}



