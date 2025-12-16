//
//  RecipeDetailView.swift
//  Lunchy
//
//  Created by Paulina Vara on 08/12/25.
//

import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query private var favoriteRecipes: [FavoriteRecipe]

    @StateObject var viewModel: RecipeDetailViewModel

    @State private var showToast = false
    @State private var toastText = ""
    @State private var isFav = false

    var body: some View {
        ZStack {
            Color.lunchyBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                headerBar

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        titleRow

                        Text("Tiempo estimado")
                            .font(.system(size: 16, weight: .semibold))

                        timeCard

                        Text("Ingredientes")
                            .font(.system(size: 16, weight: .semibold))

                        ingredientsCard

                        Text("Preparación")
                            .font(.system(size: 16, weight: .semibold))

                        stepsCard
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationBarHidden(true)
        .overlay(alignment: .bottom) {
            if showToast {
                ToastView(text: toastText)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onAppear {
            refreshFavoriteState()
        }
    }

    // MARK: - Header

    private var headerBar: some View {
        ZStack {
            Color.lunchyLightBlue.ignoresSafeArea(edges: .top)

            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                }

                Spacer()

                Image("lunchy_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)

                Spacer()

                // espacio para centrar el logo respecto al botón
                Color.clear.frame(width: 24)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .frame(height: 100)
    }

    private var titleRow: some View {
        HStack {
            Text(viewModel.recipe.nombre)
                .font(.system(size: 24, weight: .bold))

            Spacer()

            Button {
                toggleFavorite()
            } label: {
                Image(systemName: isFav ? "heart.fill" : "heart")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
        }
    }

    private var isFavorite: Bool {
        favoriteRecipes.contains(where: { $0.recipeName == viewModel.recipe.nombre })
    }
    
    private func refreshFavoriteState() {
        let name = viewModel.recipe.nombre
        let descriptor = FetchDescriptor<FavoriteRecipe>(
            predicate: #Predicate { $0.recipeName == name }
        )
        let count = (try? modelContext.fetchCount(descriptor)) ?? 0
        isFav = count > 0
    }

    private func toggleFavorite() {
        do {
            if let existing = favoriteRecipes.first(where: { $0.recipeName == viewModel.recipe.nombre }) {
                modelContext.delete(existing)
                try modelContext.save()
                showToastMessage("Se ha eliminado de favoritos")
                refreshFavoriteState()
            } else {
                modelContext.insert(FavoriteRecipe(recipeName: viewModel.recipe.nombre))
                try modelContext.save()
                showToastMessage("Se ha agregado a favoritos")
                refreshFavoriteState()
            }

            // Debug rápido
            let all = try modelContext.fetch(FetchDescriptor<FavoriteRecipe>())
            print("Favorites en DB:", all.map(\.recipeName))

        } catch {
            print("SwiftData save error:", error)
            showToastMessage("Error al guardar favoritos")
        }
    }


    private func showToastMessage(_ text: String) {
        toastText = text
        withAnimation(.easeInOut) { showToast = true }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation(.easeInOut) { showToast = false }
        }
    }

    // MARK: - Cards

    private var timeCard: some View {
        VStack(spacing: 0) {
            timeRow(label: "Preparación", value: "\(viewModel.recipe.tiempo_preparacion_min) minutos")

            Divider().padding(.horizontal, 4).padding(.vertical, 6)

            timeRow(label: "Cocción", value: "\(viewModel.recipe.tiempo_coccion_min) minutos")

            Divider().padding(.horizontal, 4).padding(.vertical, 6)

            timeRow(label: "Total", value: "\(viewModel.totalTime) minutos")
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white)
        .cornerRadius(18)
    }

    private func timeRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
        }
        .font(.system(size: 15))
        .padding(.vertical, 10)
    }

    private var ingredientsCard: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.ingredients) { ing in
                HStack {
                    Text(ing.nombre)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("\(viewModel.formattedQuantity(ing.cantidad)) \(ing.unidad)")
                        .frame(alignment: .trailing)
                }
                .font(.system(size: 15))
                .padding(.vertical, 12)

                if ing.id != viewModel.ingredients.last?.id {
                    Divider()
                        .padding(.horizontal, 4)
                        .padding(.vertical, 4)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white)
        .cornerRadius(18)
    }

    private var stepsCard: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.recipe.pasos, id: \.self) { step in
                Text(step)
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)

                if step != viewModel.recipe.pasos.last {
                    Divider().padding(.horizontal, 4).padding(.vertical, 6)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white)
        .cornerRadius(18)
    }
}

