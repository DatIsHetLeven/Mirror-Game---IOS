//
//  ArchiveView.swift
//  Final
//
//  Created by Murat on 22/01/2024.
//

//import SwiftUI
//
//struct ArchiveView: View {
//    @State private var groupedAnswers: [String: [Answer]] = [:]
//    @State private var searchText = ""
//    let spacing: CGFloat = 20
//
//    // Bereken de breedte en hoogte van de kaarten
//    private func cardSize(for width: CGFloat) -> (width: CGFloat, height: CGFloat) {
//        let cardWidth = (width - (spacing * (3 + 1))) / 3
//        let cardHeight = cardWidth * 0.8
//        return (cardWidth, cardHeight)
//    }
//
//    var body: some View {
//        GeometryReader { geometry in
//            VStack {
//                HStack {
//                    TextField("Zoeken", text: $searchText)
//                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0))
//                        .background(Color(.systemGray6))
//                        .cornerRadius(10)
//                        .padding(.leading, 10)
//                        .frame(height: 40)
//
//                    Button(action: {
//                        // Zoekactie
//                    }) {
//                        Image(systemName: "magnifyingglass")
//                            .foregroundColor(.gray)
//                            .padding()
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.top, 10)
//
//                ScrollView {
//                    let size = cardSize(for: geometry.size.width)
//                    LazyVGrid(columns: [GridItem(.fixed(size.width)), GridItem(.fixed(size.width)), GridItem(.fixed(size.width))], spacing: spacing) {
//                        ForEach(Array(groupedAnswers.keys.filter { $0.localizedCaseInsensitiveContains(searchText) || searchText.isEmpty }.sorted()), id: \.self) { gameName in
//                            NavigationLink(destination: DetailView(answers: groupedAnswers[gameName] ?? [], gameName: gameName)) {
//                                ArchiveCardView(gameName: gameName, width: size.width, height: size.height)
//                            }
//                        }
//                    }
//                    .padding([.horizontal, .bottom], spacing)
//                }
//                .padding(.leading, geometry.safeAreaInsets.leading)
//            }
//        }
//        .navigationTitle("Gespeelde spellen")
//        .onAppear {
//            fetchAnswers()
//        }
//    }
//
//    func fetchAnswers() {
//        guard let url = URL(string: "http://localhost:8080/answers") else { return }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//
//            guard let data = data else { return }
//
//            do {
//                let response = try JSONDecoder().decode(ApiResponse.self, from: data)
//                if response.success {
//                    DispatchQueue.main.async {
//                        self.groupedAnswers = Dictionary(grouping: response.data, by: { $0.gameName })
//                    }
//                } else {
//                    print("Error: API response not successful")
//                }
//            } catch {
//                print("Error: \(error)")
//            }
//        }.resume()
//    }
//
//    struct ApiResponse: Codable {
//        var success: Bool
//        var message: String
//        var statusCode: Int
//        var data: [Answer]
//        var errors: [String]
//    }
//
//    struct Answer: Codable {
//        var id: Int
//        var gameId: Int
//        var gameName: String
//        var question: String
//        var questionId: String
//        var answerText: String
//        var dateAnswered: String
//        var writtenByUser: String
//        var writtenByUserId: Int
//    }
//
//    struct DetailView: View {
//        var answers: [Answer]
//        var gameName: String
//
//        var body: some View {
//            List(answers, id: \.id) { answer in
//                VStack(alignment: .leading) {
//                    Text(answer.question)
//                        .font(.headline)
//                    Text(answer.answerText)
//                        .font(.subheadline)
//                    Text("Beantwoord op: \(answer.dateAnswered)")
//                        .font(.footnote)
//                        .foregroundColor(.gray)
//                }
//            }
//            .navigationTitle(gameName)
//        }
//    }
//}
//
//struct ArchiveCardView: View {
//    var gameName: String
//    var width: CGFloat
//    var height: CGFloat
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            Rectangle()
//                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom))
//                .frame(height: height / 2)
//
//            Text(gameName)
//                .font(.system(size: 18, weight: .bold))
//                .foregroundColor(.black)
//                .padding([.top, .horizontal])
//
//            Rectangle()
//                .fill(Color.orange)
//                .frame(height: 1)
//                .padding(.horizontal)
//
//            Spacer()
//        }
//        .frame(width: width, height: height)
//        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(radius: 2)
//    }
//}




















import SwiftUI
import PDFKit
import UIKit

struct ArchiveView: View {
    @State private var groupedAnswers: [String: [Answer]] = [:]
    @State private var searchText = ""
    let spacing: CGFloat = 20
    @State private var isPDFGenerating = false // Om de PDF-generatiestatus bij te houden

    // Bereken de breedte en hoogte van de kaarten
    private func cardSize(for width: CGFloat) -> (width: CGFloat, height: CGFloat) {
        let cardWidth = (width - (spacing * (3 + 1))) / 3
        let cardHeight = cardWidth * 0.8
        return (cardWidth, cardHeight)
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
                        // Zoekactie
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)

                ScrollView {
                    let size = cardSize(for: geometry.size.width)
                    LazyVGrid(columns: [GridItem(.fixed(size.width)), GridItem(.fixed(size.width)), GridItem(.fixed(size.width))], spacing: spacing) {
                        ForEach(Array(groupedAnswers.keys.filter { $0.localizedCaseInsensitiveContains(searchText) || searchText.isEmpty }.sorted()), id: \.self) { gameName in
                            NavigationLink(destination: DetailView(answers: groupedAnswers[gameName] ?? [], gameName: gameName)) {
                                ArchiveCardView(gameName: gameName, width: size.width, height: size.height)
                            }
                        }
                    }
                    .padding([.horizontal, .bottom], spacing)
                }
                .padding(.leading, geometry.safeAreaInsets.leading)
            }
        }
        .navigationTitle("Gespeelde spellen")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Code om de PDF te genereren
                    isPDFGenerating = true

                    // Maak een PDF-document aan
                    let pdf = PDFDocument()

                    for (gameName, answers) in groupedAnswers {
                        // Voeg de naam van de cardset toe bovenaan de PDF
                        let cardsetNameText = gameName

                        // Voeg de antwoorden toe aan de PDF
                        for answer in answers {
                            let questionText = answer.question
                            let answerText = answer.answerText
                            let dateText = "Beantwoord op: \(answer.dateAnswered)"

                            if let page = createPDFPageWithText(text: cardsetNameText + "\n" + questionText + "\n" + answerText + "\n" + dateText) {
                                pdf.insert(page, at: pdf.pageCount)
                            }
                        }
                    }

                    // Sla de PDF op op het bureaublad van de iPad
                    if let desktopURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let pdfURL = desktopURL.appendingPathComponent("Gespeelde_spellen.pdf")

                        do {
                            try pdf.write(to: pdfURL)
                            
                            // Toon een bericht dat de PDF is opgeslagen
                            let alert = UIAlertController(title: "PDF opgeslagen", message: "Het PDF-bestand is opgeslagen op het bureaublad van de iPad.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)

                        } catch {
                            print("Fout bij opslaan van PDF: \(error.localizedDescription)")
                        }
                    }

                    isPDFGenerating = false
                }) {
                    HStack {
                        Text("PDF")
                        if isPDFGenerating {
                            ProgressView()
                        }
                    }
                }
                .disabled(isPDFGenerating)
            }
        }
        .onAppear {
            fetchAnswers()
        }
    }
    
    func fetchAnswers() {
        guard let url = URL(string: "http://localhost:8080/answers") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(ApiResponse.self, from: data)
                if response.success {
                    DispatchQueue.main.async {
                        self.groupedAnswers = Dictionary(grouping: response.data, by: { $0.gameName })
                    }
                } else {
                    print("Error: API response not successful")
                }
            } catch {
                print("Error: \(error)")
            }
        }.resume()
    }
    
    
    // Aangepaste functie om een PDFPage te maken van tekst
        private func createPDFPageWithText(text: String) -> PDFPage? {
            let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792) // Standaardpaginaformaat (8.5 x 11 inch)
            let pdfPage = PDFPage()

            let textLayer = CATextLayer()
            textLayer.string = text
            textLayer.frame = pageRect
            textLayer.contentsScale = UIScreen.main.scale

            UIGraphicsBeginPDFPageWithInfo(pageRect, nil)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            pdfPage.draw(with: .cropBox, to: context)

            textLayer.render(in: context)
            UIGraphicsEndPDFContext()

            return pdfPage
        }

        // Aangepaste functie om de PDF op te slaan op het bureaublad van de iPad
        private func savePDFToDesktop() {
            // Maak een PDF-document aan
            let pdf = PDFDocument()

            for (gameName, answers) in groupedAnswers {
                // Voeg de naam van de cardset toe bovenaan de PDF
                let cardsetNameText = gameName

                // Voeg de antwoorden toe aan de PDF
                for answer in answers {
                    let questionText = answer.question
                    let answerText = answer.answerText
                    let dateText = "Beantwoord op: \(answer.dateAnswered)"

                    if let page = createPDFPageWithText(text: cardsetNameText + "\n" + questionText + "\n" + answerText + "\n" + dateText) {
                        pdf.insert(page, at: pdf.pageCount)
                    }
                }
            }

            // Zoek de map van de iCloud Drive op de iPad
            if let iCloudDriveURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
                // Stel de bestemmings-URL in voor de PDF op het bureaublad
                let pdfURL = iCloudDriveURL.appendingPathComponent("Gespeelde_spellen.pdf")

                do {
                    // Sla de PDF op
                    try pdf.write(to: pdfURL)
                    
                    // Toon een bericht dat de PDF is opgeslagen
                    let alert = UIAlertController(title: "PDF opgeslagen", message: "Het PDF-bestand is opgeslagen op het bureaublad van de iPad.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)

                } catch {
                    print("Fout bij opslaan van PDF: \(error.localizedDescription)")
                }
            } else {
                print("iCloud Drive niet beschikbaar op deze iPad.")
            }
        }
}
    



    struct ApiResponse: Codable {
        var success: Bool
        var message: String
        var statusCode: Int
        var data: [Answer]
        var errors: [String]
    }

    struct Answer: Codable {
        var id: Int
        var gameId: Int
        var gameName: String
        var question: String
        var questionId: String
        var answerText: String
        var dateAnswered: String
        var writtenByUser: String
        var writtenByUserId: Int
    }

    struct DetailView: View {
        var answers: [Answer]
        var gameName: String

        var body: some View {
            List(answers, id: \.id) { answer in
                VStack(alignment: .leading) {
                    Text(answer.question)
                        .font(.headline)
                    Text(answer.answerText)
                        .font(.subheadline)
                    Text("Beantwoord op: \(answer.dateAnswered)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle(gameName)
        }
    }


struct ArchiveCardView: View {
    var gameName: String
    var width: CGFloat
    var height: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom))
                .frame(height: height / 2)

            Text(gameName)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
                .padding([.top, .horizontal])

            Rectangle()
                .fill(Color.orange)
                .frame(height: 1)
                .padding(.horizontal)

            Spacer()
        }
        .frame(width: width, height: height)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

