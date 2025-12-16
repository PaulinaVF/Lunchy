//
//  MatchViewModel.swift
//  Lunchy
//
//  Created by Paulina Vara on 08/12/25.
//

import Foundation
import SwiftData

final class MatchViewModel: ObservableObject {

    struct DisplayIngredient: Identifiable {
        let id: String
        let nombre: String
        let cantidad: Double
        let unidad: String
    }

    struct MatchRecipe: Identifiable {
        let id = UUID()
        let recipe: Recipe
        let ingredientes: [DisplayIngredient]
        let missingCount: Int
    }

    @Published var matches: [MatchRecipe] = []

    private let recipes: [Recipe]
    private let ingredientsById: [String: Ingredient]

    init(recipes: [Recipe]) {
        self.recipes = recipes
        let allIngredients = DataService.shared.loadIngredients()
        self.ingredientsById = Dictionary(uniqueKeysWithValues: allIngredients.map { ($0.id, $0) })
    }

    func updateMatches(
        stocks: [IngredientStock],
        filters: RecipeFilters,
        favoriteNames: Set<String>
    ) {
        var result: [MatchRecipe] = []

        for recipe in recipes {
            // Solo favoritos
            if filters.onlyFavorites, !favoriteNames.contains(recipe.nombre) {
                continue
            }

            // Tiempo (siempre aplica)
            if recipe.tiempoTotal > filters.maxTime {
                continue
            }

            // Tipo
            if !filters.selectedTypes.isEmpty {
                let t = RecipeType(rawValue: recipe.tipo) ?? .vegetal
                if !filters.selectedTypes.contains(t) { continue }
            }

            // Regla match: 0 o 1 faltante
            var missing = 0
            for req in recipe.ingredientes {
                let have = stocks.first(where: { $0.ingredientId == req.id })?.quantity ?? 0
                if have + 0.0001 < req.cantidad {
                    missing += 1
                    if missing > 1 { break }
                }
            }
            guard missing <= 1 else { continue }

            let displayIngredients: [DisplayIngredient] = recipe.ingredientes.compactMap { req in
                guard let ing = ingredientsById[req.id] else { return nil }
                return DisplayIngredient(
                    id: req.id,
                    nombre: ing.nombre,
                    cantidad: req.cantidad,
                    unidad: req.unidad
                )
            }

            result.append(MatchRecipe(recipe: recipe, ingredientes: displayIngredients, missingCount: missing))
        }

        DispatchQueue.main.async {
            self.matches = result
        }
    }

    func imageName(for type: String) -> String {
        switch type {
        case "carne": return "meat"
        case "sopa": return "pasta"
        case "dulce": return "sweet"
        case "vegetal": return "veggie"
        default: return "veggie"
        }
    }

    func formatted(_ quantity: Double) -> String {
        if quantity == floor(quantity) { return String(Int(quantity)) }
        return String(format: "%.1f", quantity)
    }
}
