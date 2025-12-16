//
//  RecipeFilters.swift
//  Lunchy
//
//  Created by Paulina Vara on 15/12/25.
//

import Foundation

enum RecipeType: String, CaseIterable, Identifiable, Codable {
    case sopa, vegetal, carne, dulce
    var id: String { rawValue }

    var title: String {
        switch self {
        case .sopa: return "Sopa"
        case .vegetal: return "Vegetal"
        case .carne: return "Carne"
        case .dulce: return "Dulce"
        }
    }
}

struct RecipeFilters: Equatable, Codable {
    var maxTime: Int = 120
    var selectedTypes: Set<RecipeType> = []
    var onlyFavorites: Bool = false

    var isActive: Bool {
        (maxTime < 120) || !selectedTypes.isEmpty || onlyFavorites
    }
}
