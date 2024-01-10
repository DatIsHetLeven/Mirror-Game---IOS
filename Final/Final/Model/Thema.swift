//
//  Thema.swift
//  Final
//
//  Created by Murat on 03/01/2024.
//

struct Theme: Codable, Identifiable {
    var id: Int?
    var name: String
    var color: String
    var description: String
    var fontType: String
}
