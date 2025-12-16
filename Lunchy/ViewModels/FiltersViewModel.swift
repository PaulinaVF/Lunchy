//
//  FiltersViewModel.swift
//  Lunchy
//
//  Created by Paulina Vara on 15/12/25.
//

import Foundation

final class FiltersViewModel: ObservableObject {
    @Published var filters = RecipeFilters()

    func clear() {
        filters = RecipeFilters()
    }

    func activeDescription() -> String {
        var parts: [String] = []

        if filters.maxTime < 120 {
            parts.append("Tiempo máx: \(filters.maxTime) min")
        }

        if !filters.selectedTypes.isEmpty {
            let types = filters.selectedTypes.map { $0.title }.sorted().joined(separator: ", ")
            parts.append("Tipo: \(types)")
        }

        if filters.onlyFavorites {
            parts.append("Solo favoritos")
        }

        return parts.joined(separator: " · ")
    }
}
