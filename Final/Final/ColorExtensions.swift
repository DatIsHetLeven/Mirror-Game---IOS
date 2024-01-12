//
//  ColorExtensions.swift
//  Final
//
//  Created by Murat on 12/01/2024.
//

import Foundation
import SwiftUI

extension Color {
    func toHex() -> String {
        // Voorbeeldimplementatie. Pas deze aan op basis van je behoeften
        // en het kleurenmodel dat je app gebruikt.
        guard let components = cgColor?.components, components.count >= 3 else {
            return "#000000"
        }
        let r = components[0]
        let g = components[1]
        let b = components[2]
        return String(format: "#%02lX%02lX%02lX",
                      lroundf(Float(r * 255)),
                      lroundf(Float(g * 255)),
                      lroundf(Float(b * 255)))
    }
}
