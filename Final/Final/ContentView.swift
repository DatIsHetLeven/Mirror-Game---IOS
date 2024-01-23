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

//struct ContentView: View {
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Color(hex: "FFE5B4").edgesIgnoringSafeArea(.all)
//
//                List {
//                    CustomNavigationLink(destination: HomeView()) {
//                        Label("Home", systemImage: "house")
//                    }
//                    CustomNavigationLink(destination: CreateDeck()) {
//                        Label("Create Deck", systemImage: "plus.rectangle.on.rectangle")
//                    }
//                    CustomNavigationLink(destination: PlayGame()) {
//                        Label("Play Game", systemImage: "gamecontroller")
//                    }
//                    CustomNavigationLink(destination: CardSetsView()) {
//                        Label("Card Decks", systemImage: "cards")
//                    }
//                    CustomNavigationLink(destination: ArchiveView()) {
//                        Label("Archive", systemImage: "tray.full")
//                    }
//                }
//                .listStyle(PlainListStyle())
//                .listRowBackground(Color(hex: "FFE5B4"))
//            }
//        }
//    }
//}

struct ContentView: View {
    @State private var isLoading = true // Een staat om te controleren of het laden actief is

    var body: some View {
        NavigationView {
            ZStack {
                if isLoading {
                    LoadingView()
                        .background(Color(hex: "FFE5B4"))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all) // Hiermee wordt het laadscherm over het hele scherm geplaatst
                }
                
                Color(hex: "FFE5B4").edgesIgnoringSafeArea(.all)

                List {
                    CustomNavigationLink(destination: HomeView()) {
                        Label("Home", systemImage: "house")
                    }
                    CustomNavigationLink(destination: CreateDeck()) {
                        Label("Set Aanmaken", systemImage: "plus.rectangle.on.rectangle")
                    }
                    CustomNavigationLink(destination: PlayGame()) {
                        Label("Speel Spel", systemImage: "gamecontroller")
                    }
                    CustomNavigationLink(destination: CardSetsView()) {
                        Label("Mijn Sets", systemImage: "rectangle.grid.1x2.fill")
                    }
                    CustomNavigationLink(destination: ArchiveView()) {
                        Label("Archief", systemImage: "tray.full")
                    }
                }
                .listStyle(PlainListStyle())
                .listRowBackground(Color(hex: "FFE5B4"))
                

            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                isLoading = false // Voorbeeld: schakel isLoading uit na 3 seconden 
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
                .foregroundColor(.black)
        }
        .accentColor(.gray)
        .buttonStyle(PlainButtonStyle())
        .listRowBackground(Color(hex: "FFE5B4"))
    }
}

struct HomeView: View {
    var body: some View {
        Text("Home Page")
            .navigationBarTitle("", displayMode: .large)
        
        
        
        
        Image("Image")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 600, height: 600) 
        
        
        
        


    }
}

