//
//  LunchyApp.swift
//  Lunchy
//
//  Created by Paulina Vara on 08/12/25.
//

import SwiftUI

@main
struct LunchyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: IngredientStock.self)
    }
}
