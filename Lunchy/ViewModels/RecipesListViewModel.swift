//
//  RecipesListViewModel.swift
//  Lunchy
//
//  Created by Paulina Vara on 08/12/25.
//

import Foundation

final class RecipesListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []

    init() {
        recipes = DataService.shared.loadRecipes()
    }

    func filteredRecipes(using filters: RecipeFilters, favorites: [FavoriteRecipe]) -> [Recipe] {
        recipes.filter { r in
            // Tiempo
            let timeOk = r.tiempoTotal <= filters.maxTime

            // Tipo
            let typeOk: Bool = {
                if filters.selectedTypes.isEmpty { return true }
                let t = RecipeType(rawValue: r.tipo) ?? .vegetal
                return filters.selectedTypes.contains(t)
            }()

            // Solo favoritos
            let favOk: Bool = {
                guard filters.onlyFavorites else { return true }
                return favorites.contains(where: { $0.recipeName == r.nombre })
            }()

            return timeOk && typeOk && favOk
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
}
