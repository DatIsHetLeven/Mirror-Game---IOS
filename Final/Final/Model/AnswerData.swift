//
//  AnswerData.swift
//  Final
//
//  Created by Murat on 23/01/2024.
//

import Foundation

struct AnswerData: Codable {
    let gameId: Int
    let gameName: String
    let question: String
    let questionId: String
    let answerText: String
    let dateAnswered: String
    let writtenByUser: String
    let writtenByUserId: Int
}

struct AnswerResponse: Codable {
    // Structuur gebaseerd op het verwachte antwoord van de server
}
