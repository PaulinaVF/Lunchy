//
//  IngredientsViewModel.swift
//  Lunchy
//
//  Created by Paulina Vara on 08/12/25.
//

import Foundation
import SwiftData

final class IngredientsViewModel: ObservableObject {
    @Published var ingredientsByCategory: [String: [Ingredient]] = [:]

    init() {
        let all = DataService.shared.loadIngredients()
        ingredientsByCategory = Dictionary(grouping: all, by: { $0.categoria })
    }

    var sortedCategories: [String] {
        ingredientsByCategory.keys.sorted()
    }

    func displayName(for category: String) -> String {
        switch category {
        case "frutas_y_verduras": return "Frutas y verduras"
        case "carne_pollo_pescado": return "Carnes"
        case "condimentos": return "Condimentos"
        case "cereales": return "Cereales"
        case "dulces": return "Dulces"
        default: return category.capitalized
        }
    }

    func unit(for ingredient: Ingredient) -> String {
        ingredient.unidad
    }

    func quantity(
        for ingredient: Ingredient,
        stocks: [IngredientStock]
    ) -> Double {
        stocks.first { $0.ingredientId == ingredient.id }?.quantity ?? 0
    }

    func setQuantity(
        _ value: Double,
        for ingredient: Ingredient,
        context: ModelContext,
        stocks: [IngredientStock]
    ) {
        if let existing = stocks.first(where: { $0.ingredientId == ingredient.id }) {
            existing.quantity = max(0, value)
        } else {
            let stock = IngredientStock(ingredientId: ingredient.id, quantity: max(0, value))
            context.insert(stock)
        }
    }

    func formatted(_ quantity: Double) -> String {
        if quantity == floor(quantity) {
            return String(Int(quantity))
        } else {
            return String(format: "%.1f", quantity)
        }
    }
}

