//
//  RecipesListView.swift
//  Lunchy
//
//  Created by Paulina Vara on 08/12/25.
//

import SwiftUI
import SwiftData

struct RecipesListView: View {
    @StateObject var viewModel: RecipesListViewModel

    @EnvironmentObject private var filtersVM: FiltersViewModel

    @State private var showFiltersSheet = false
    @State private var showMatch = false

    @Query private var favoriteRecipes: [FavoriteRecipe]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.lunchyBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    headerLogo

                    VStack(spacing: 16) {
                        buttonsRow

                        if filtersVM.filters.isActive {
                            activeFiltersRow
                        }

                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(viewModel.filteredRecipes(using: filtersVM.filters, favorites: favoriteRecipes)) { recipe in
                                    NavigationLink {
                                        RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: recipe))
                                    } label: {
                                        RecipeRow(
                                            recipe: recipe,
                                            imageName: viewModel.imageName(for: recipe.tipo)
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 24)
                        }
                    }
                    .padding(.top, 16)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showMatch) {
                MatchView(viewModel: MatchViewModel(recipes: viewModel.recipes))
            }
            .sheet(isPresented: $showFiltersSheet) {
                FiltersSheetView(current: filtersVM.filters) { newFilters in
                    filtersVM.filters = newFilters
                }
            }
        }
    }

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

    private var buttonsRow: some View {
        HStack(spacing: 16) {
            Button {
                showMatch = true
            } label: {
                Text("Buscar un match")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.lunchyBlue)
                    .foregroundColor(.white)
                    .cornerRadius(18)
            }

            Button { showFiltersSheet = true } label: {
                Text("Filtros")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.lunchyBlue)
                    .cornerRadius(18)
            }
        }
        .padding(.horizontal)
    }

    private var activeFiltersRow: some View {
        HStack(spacing: 12) {
            Text(filtersVM.activeDescription())
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black.opacity(0.7))
                .lineLimit(2)

            Spacer()

            Button("Eliminar filtros") { filtersVM.clear() }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.lunchyBlue)
        }
        .padding(.horizontal)
        .padding(.top, 4)
    }
}
