//
//  FavoriteRecipe.swift
//  Lunchy
//
//  Created by Paulina Vara on 16/12/25.
//

import Foundation
import SwiftData

@Model
final class FavoriteRecipe {
    @Attribute(.unique) var recipeName: String
    var createdAt: Date

    init(recipeName: String, createdAt: Date = .now) {
        self.recipeName = recipeName
        self.createdAt = createdAt
    }
}
