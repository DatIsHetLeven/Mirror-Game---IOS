
import SwiftUI

struct CardSetsView: View {
    @StateObject private var viewModel = CardSetViewModel()
    @ObservedObject private var reloadManager = ReloadManager()
    let spacing: CGFloat = 20

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                let availableWidth = geometry.size.width
                let cardWidth = (availableWidth - (spacing * (3 + 1))) / 3
                let cardHeight = cardWidth * 0.8

                LazyVGrid(columns: [GridItem(.fixed(cardWidth)), GridItem(.fixed(cardWidth)), GridItem(.fixed(cardWidth))], spacing: spacing) {
                    ForEach(viewModel.cardSets, id: \.id) { cardSet in
                        NavigationLink(destination: CardSetDetailView(cardSetId: cardSet.id)) {
                            CardView(reloadManager: reloadManager, cardSet: cardSet, cardWidth: cardWidth, cardHeight: cardHeight, setid: cardSet.id)
                        }
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
            .padding(.leading, geometry.safeAreaInsets.leading)
        }
        .navigationTitle("Card Sets")
    }
}



struct CardView: View {
    @State private var isEditing = false
    @State private var showingEditPopup = false
    @State private var showingDeleteAlert = false
    @ObservedObject var reloadManager: ReloadManager
    @StateObject private var viewModel = CardSetViewModel()
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
                    showingEditPopup = true
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 8)
                .padding(.trailing, 8)
                .sheet(isPresented: $showingEditPopup) {
                    EditCardSetView(setid: $setid, isPresented: $showingEditPopup, name: cardSet.name, description: cardSet.description)
                }

                Button(action: {
                    showingDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .padding(.bottom, 8)
                .alert(isPresented: $showingDeleteAlert) {
                    Alert(
                        title: Text("Verwijderen bevestigen"),
                        message: Text("U staat op het punt om de set \(cardSet.name) te verwijderen. Weet u zeker dat u dit wilt doen?"),
                        primaryButton: .destructive(Text("Ja, verwijder")) {
                            viewModel.deleteCardSet(cardSetId: cardSet.id)
                            reloadManager.shouldReload = true
                        },
                        secondaryButton: .cancel(Text("Annuleren"))
                    )
                }
            }
        }
        .frame(width: cardWidth, height: cardHeight)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct EditCardSetView: View {
    @Binding var setid: Int
    @Binding var isPresented: Bool
    @State private var name = ""
    @State private var description = ""

    init(setid: Binding<Int>, isPresented: Binding<Bool>, name: String, description: String) {
        _setid = setid
        _isPresented = isPresented
        _name = State(initialValue: name)
        _description = State(initialValue: description)
    }

    var body: some View {
        VStack {
            TextField("Naam", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Beschrijving", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            HStack {
                Button("Annuleren") {
                    isPresented = false
                }
                .padding()

                Spacer()

                Button("Opslaan") {
                    // Voer hier de bewerkingsactie uit met de waarden van de invoervelden
                    // Bijvoorbeeld: viewModel.updateCardSet(cardSetId: setid, name: name, description: description)
                    isPresented = false
                }
                .padding()
            }
        }
        .padding()
    }
}



class ReloadManager: ObservableObject {
    @Published var shouldReload = false
}
