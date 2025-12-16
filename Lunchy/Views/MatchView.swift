//
//  MatchView.swift
//  Lunchy
//
//  Created by Paulina Vara on 08/12/25.
//

import SwiftUI
import SwiftData

struct MatchView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var filtersVM: FiltersViewModel

    @Query private var stocks: [IngredientStock]
    @Query private var favoriteRecipes: [FavoriteRecipe]

    @StateObject var viewModel: MatchViewModel
    @State private var showFiltersSheet = false

    var body: some View {
        ZStack {
            Color.lunchyBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                headerBar

                ScrollView {
                    VStack(spacing: 10) {
                        Text("Aquí están tus match!")
                            .font(.system(size: 24, weight: .bold))
                            .padding(.top, 20)

                        if filtersVM.filters.isActive {
                            activeFiltersRow
                        }

                        if viewModel.matches.isEmpty {
                            Text("No hay recetas que coincidan con tus ingredientes y filtros.")
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .padding(.top, 24)
                        } else {
                            TabView {
                                ForEach(viewModel.matches) { match in
                                    matchCard(match)
                                }
                            }
                            .tabViewStyle(.page)
                            .indexViewStyle(.page(backgroundDisplayMode: .always))
                            .frame(height: 560)
                            .padding(.top, 0)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear { refresh() }
        .onChange(of: stocks) { refresh() }
        .onChange(of: favoriteRecipes) { refresh() }
        .onChange(of: filtersVM.filters) { refresh() }
        .sheet(isPresented: $showFiltersSheet) {
            FiltersSheetView(current: filtersVM.filters) { newFilters in
                filtersVM.filters = newFilters
            }
        }
        .navigationBarHidden(true)
    }

    private func refresh() {
        let favNames = Set(favoriteRecipes.map(\.recipeName))
        viewModel.updateMatches(stocks: stocks, filters: filtersVM.filters, favoriteNames: favNames)
    }

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

                Button { showFiltersSheet = true } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .frame(height: 100)
    }

    private var activeFiltersRow: some View {
        HStack(spacing: 12) {
            Text(filtersVM.activeDescription())
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black.opacity(0.7))
                .lineLimit(2)

            Spacer()

            Button("Eliminar filtros") {
                filtersVM.clear()
            }
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.lunchyBlue)
        }
        .padding(.horizontal, 24)
        .padding(.top, 4)
    }

    private func matchCard(_ match: MatchViewModel.MatchRecipe) -> some View {
        VStack(spacing: 12) {
            Image(viewModel.imageName(for: match.recipe.tipo))
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)

            Text(match.recipe.nombre)
                .font(.system(size: 22, weight: .bold))

            VStack(spacing: 10) {
                ForEach(match.ingredientes) { ing in
                    HStack {
                        Text(ing.nombre)
                        Spacer()
                        Text("\(viewModel.formatted(ing.cantidad)) \(ing.unidad)")
                    }
                    .font(.system(size: 16))

                    if ing.id != match.ingredientes.last?.id {
                        Divider().padding(.horizontal, 4).padding(.vertical, 6)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .background(Color.white)
            .cornerRadius(24)
        }
        .padding(.horizontal, 24)
        .padding(.top, 0)
    }
}
