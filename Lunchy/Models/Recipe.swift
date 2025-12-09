//
//  Recipe.swift
//  Lunchy
//
//  Created by Paulina Vara on 08/12/25.
//

import Foundation

struct RecipeIngredientRequirement: Codable, Identifiable {
    let id: String          // id de ingrediente, coincide con Ingredient.id
    let cantidad: Double
    let unidad: String
}

struct Recipe: Identifiable, Codable {
    let id: UUID
    let nombre: String
    let tipo: String
    let ingredientes: [RecipeIngredientRequirement]
    let tiempo_preparacion_min: Int
    let tiempo_coccion_min: Int
    let pasos: [String]

    var tiempoTotal: Int {
        tiempo_preparacion_min + tiempo_coccion_min
    }

    enum CodingKeys: String, CodingKey {
        case nombre, tipo, ingredientes, tiempo_preparacion_min, tiempo_coccion_min, pasos
    }

    init(
        id: UUID = UUID(),
        nombre: String,
        tipo: String,
        ingredientes: [RecipeIngredientRequirement],
        tiempo_preparacion_min: Int,
        tiempo_coccion_min: Int,
        pasos: [String]
    ) {
        self.id = id
        self.nombre = nombre
        self.tipo = tipo
        self.ingredientes = ingredientes
        self.tiempo_preparacion_min = tiempo_preparacion_min
        self.tiempo_coccion_min = tiempo_coccion_min
        self.pasos = pasos
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        nombre = try c.decode(String.self, forKey: .nombre)
        tipo = try c.decode(String.self, forKey: .tipo)
        ingredientes = try c.decode([RecipeIngredientRequirement].self, forKey: .ingredientes)
        tiempo_preparacion_min = try c.decode(Int.self, forKey: .tiempo_preparacion_min)
        tiempo_coccion_min = try c.decode(Int.self, forKey: .tiempo_coccion_min)
        pasos = try c.decode([String].self, forKey: .pasos)
        id = UUID()
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(nombre, forKey: .nombre)
        try c.encode(tipo, forKey: .tipo)
        try c.encode(ingredientes, forKey: .ingredientes)
        try c.encode(tiempo_preparacion_min, forKey: .tiempo_preparacion_min)
        try c.encode(tiempo_coccion_min, forKey: .tiempo_coccion_min)
        try c.encode(pasos, forKey: .pasos)
    }
}
