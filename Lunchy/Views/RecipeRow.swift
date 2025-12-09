//
//  RecipeRow.swift
//  Lunchy
//
//  Created by Paulina Vara on 08/12/25.
//

import SwiftUI

struct RecipeRow: View {
    let recipe: Recipe
    let imageName: String

    var body: some View {
        HStack(spacing: 16) {
            Image(imageName)
                .resizable()
                .frame(width: 48, height: 48)

            Text(recipe.nombre)
                .font(.system(size: 18, weight: .medium))

            Spacer()

            Text("\(recipe.tiempoTotal) min")
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
    }
}
