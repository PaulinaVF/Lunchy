//
//  DataService.swift
//  Lunchy
//
//  Created by Paulina Vara on 08/12/25.
//

import Foundation

final class DataService {
    static let shared = DataService()

    func loadRecipes() -> [Recipe] {
        guard let url = Bundle.main.url(forResource: "Recetas", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([Recipe].self, from: data)
        else { return [] }

        return decoded
    }

    func loadIngredients() -> [Ingredient] {
        guard let url = Bundle.main.url(forResource: "Ingredientes", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([Ingredient].self, from: data)
        else { return [] }

        return decoded
    }
}
