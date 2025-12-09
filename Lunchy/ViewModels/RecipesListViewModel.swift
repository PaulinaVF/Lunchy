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
