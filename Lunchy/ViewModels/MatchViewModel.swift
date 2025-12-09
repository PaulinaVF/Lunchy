//
//  MatchViewModel.swift
//  Lunchy
//
//  Created by Paulina Vara on 08/12/25.
//

import Foundation

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
    }

    @Published var matches: [MatchRecipe] = []

    private let recipes: [Recipe]
    private let ingredientsById: [String: Ingredient]

    init(recipes: [Recipe]) {
        self.recipes = recipes
        let allIngredients = DataService.shared.loadIngredients()
        self.ingredientsById = Dictionary(uniqueKeysWithValues: allIngredients.map { ($0.id, $0) })
    }

    func updateMatches(stocks: [IngredientStock]) {
        var result: [MatchRecipe] = []

        for recipe in recipes {
            var missingCount = 0

            for req in recipe.ingredientes {
                let have = stocks.first(where: { $0.ingredientId == req.id })?.quantity ?? 0
                if have + 0.0001 < req.cantidad { // pequeño margen
                    missingCount += 1
                    if missingCount > 1 { break }
                }
            }

            // Aceptar recetas con 0 ingredientes faltantes o solo 1
            guard missingCount <= 1 else { continue }

            let displayIngredients: [DisplayIngredient] = recipe.ingredientes.compactMap { req in
                guard let ing = ingredientsById[req.id] else { return nil }
                return DisplayIngredient(
                    id: req.id,
                    nombre: ing.nombre,
                    cantidad: req.cantidad,
                    unidad: req.unidad
                )
            }

            result.append(MatchRecipe(recipe: recipe, ingredientes: displayIngredients))
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
        if quantity == floor(quantity) {
            return String(Int(quantity))
        } else {
            return String(format: "%.1f", quantity)
        }
    }
}
