//
//  Ingredient.swift
//  Lunchy
//
//  Created by Paulina Vara on 08/12/25.
//

import Foundation

struct Ingredient: Identifiable, Codable {
    let id: String        // coincide con el "id" del JSON
    let nombre: String
    let categoria: String
}
