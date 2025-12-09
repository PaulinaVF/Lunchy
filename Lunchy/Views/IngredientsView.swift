//
//  IngredientsView.swift
//  Lunchy
//
//  Created by Paulina Vara on 08/12/25.
//

import SwiftUI
import SwiftData

struct IngredientsView: View {
    @StateObject var viewModel: IngredientsViewModel

    @Environment(\.modelContext) private var modelContext
    @Query private var stocks: [IngredientStock]

    @State private var editingIngredient: Ingredient?
    @State private var quantityText: String = ""
    @State private var showingEditAlert = false

    var body: some View {
        ZStack {
            Color.lunchyBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                headerLogo

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        ForEach(viewModel.sortedCategories, id: \.self) { category in
                            if let ingredients = viewModel.ingredientsByCategory[category] {
                                categorySection(
                                    title: viewModel.displayName(for: category),
                                    ingredients: ingredients
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 24)
                    .padding(.bottom, 32)
                }
            }
        }
        .alert(
            "Editar cantidad",
            isPresented: $showingEditAlert,
            presenting: editingIngredient
        ) { ingredient in
            TextField("Cantidad", text: $quantityText)
                .keyboardType(.decimalPad)

            Button("Guardar") {
                let value = Double(quantityText.replacingOccurrences(of: ",", with: ".")) ?? 0
                viewModel.setQuantity(
                    value,
                    for: ingredient,
                    context: modelContext,
                    stocks: stocks
                )
            }

            Button("Cancelar", role: .cancel) { }
        } message: { ingredient in
            Text("Ingresa la cantidad que tienes de \(ingredient.nombre) en \(viewModel.unit(for: ingredient))")
        }
    }

    // MARK: - Header

    private var headerLogo: some View {
        ZStack {
            Color.lunchyLightBlue
                .ignoresSafeArea(edges: .top)

            Image("lunchy_logo")
                .resizable()
                .scaledToFit()
                .frame(height: 60)
        }
        .frame(height: 100)
    }

    // MARK: - Sección por categoría

    private func categorySection(title: String, ingredients: [Ingredient]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))

            VStack(spacing: 12) {      // ← antes era spacing = 0
                ForEach(ingredients) { ingredient in
                    ingredientRow(ingredient)
                    
                    if ingredient.id != ingredients.last?.id {
                        Divider()
                            .padding(.vertical, 6)  // ← agrega respiro
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(18)
        }
    }

    // MARK: - Fila de ingrediente

    private func ingredientRow(_ ingredient: Ingredient) -> some View {
        let quantity = viewModel.quantity(for: ingredient, stocks: stocks)
        let unit = viewModel.unit(for: ingredient)

        return HStack(spacing: 8) {
            Text(ingredient.nombre)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("\(viewModel.formatted(quantity)) \(unit)")
                .frame(width: 80, alignment: .trailing)

            Button {
                editingIngredient = ingredient
                quantityText = quantity == 0 ? "" : viewModel.formatted(quantity)
                showingEditAlert = true
            } label: {
                Image(systemName: "square.and.pencil")
            }

            Button {
                viewModel.setQuantity(0, for: ingredient, context: modelContext, stocks: stocks)
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(quantity == 0 ? .gray.opacity(0.3) : .black)
            }
            .disabled(quantity == 0)
        }
        .font(.system(size: 15))
        .padding(.vertical, 4)   // ← espacio entre rows
    }
}

