//
//  FavoritesViewModel.swift
//  Lunchy
//
//  Created by Paulina Vara on 16/12/25.
//

import Foundation
import SwiftData

@MainActor
final class FavoritesViewModel: ObservableObject {
    func isFavorite(_ recipe: Recipe, favorites: [FavoriteRecipe]) -> Bool {
        favorites.contains(where: { $0.recipeName == recipe.nombre })
    }

    func toggle(_ recipe: Recipe, context: ModelContext, favorites: [FavoriteRecipe]) -> Bool {
        if let existing = favorites.first(where: { $0.recipeName == recipe.nombre }) {
            context.delete(existing)
            return false
        } else {
            context.insert(FavoriteRecipe(recipeName: recipe.nombre))
            return true
        }
    }
}
