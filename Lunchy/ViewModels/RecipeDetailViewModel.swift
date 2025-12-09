//
//  RecipeDetailViewModel.swift
//  Lunchy
//
//  Created by Paulina Vara on 08/12/25.
//

import Foundation

import Foundation

final class RecipeDetailViewModel: ObservableObject {
    struct DisplayIngredient: Identifiable {
        let id: String
        let nombre: String
        let cantidad: Double
        let unidad: String
    }

    let recipe: Recipe
    @Published var ingredients: [DisplayIngredient] = []

    init(recipe: Recipe) {
        self.recipe = recipe
        loadIngredients()
    }

    private func loadIngredients() {
        let all = DataService.shared.loadIngredients()
        let dict = Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })

        ingredients = recipe.ingredientes.compactMap { requirement in
            guard let ing = dict[requirement.id] else { return nil }
            return DisplayIngredient(
                id: ing.id,
                nombre: ing.nombre,
                cantidad: requirement.cantidad,
                unidad: requirement.unidad
            )
        }
    }

    var totalTime: Int {
        recipe.tiempoTotal
    }

    func formattedQuantity(_ value: Double) -> String {
        if value == floor(value) {
            return String(Int(value))
        } else {
            return String(format: "%.1f", value)
        }
    }
}

