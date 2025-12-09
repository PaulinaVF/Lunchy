//
//  IngredientStock.swift
//  Lunchy
//
//  Created by Paulina Vara on 08/12/25.
//

import SwiftData

@Model
final class IngredientStock {
    @Attribute(.unique) var ingredientId: String
    var quantity: Double

    init(ingredientId: String, quantity: Double = 0) {
        self.ingredientId = ingredientId
        self.quantity = quantity
    }
}
