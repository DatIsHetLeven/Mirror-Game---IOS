import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "FFE5B4").edgesIgnoringSafeArea(.all)
                
                List {
                    CustomNavigationLink(destination: HomeView()) {
                        Label("Home", systemImage: "house")
                    }
                    CustomNavigationLink(destination: CreateDeck()) {
                        Label("Create Deck", systemImage: "plus.rectangle.on.rectangle")
                    }
                    CustomNavigationLink(destination: Text("Play Game View")) {
                        Label("Play Game", systemImage: "gamecontroller")
                    }
                    CustomNavigationLink(destination: CardSetsView()) {
                        Label("Card Decks", systemImage: "cards")
                    }
                    CustomNavigationLink(destination: Text("Archive View")) {
                        Label("Archive", systemImage: "tray.full")
                    }
                }
                .listStyle(PlainListStyle())
                .listRowBackground(Color(hex: "FFE5B4"))
            }
        }
    }
}

struct CustomNavigationLink<Destination: View, Label: View>: View {
    var destination: Destination
    var label: () -> Label

    init(destination: Destination, @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.label = label
    }

    var body: some View {
        NavigationLink(destination: destination) {
            label()
                .foregroundColor(.black) // Adjust as needed for contrast
        }
        .accentColor(.gray) // Color when the link is active
        .buttonStyle(PlainButtonStyle())
        .listRowBackground(Color(hex: "FFE5B4")) // Set the list row background color to your hex color
    }
}

struct HomeView: View {
    var body: some View {
        Text("Home Page")
            .navigationBarTitle("", displayMode: .large)
    }
}

