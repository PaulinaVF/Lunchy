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
    @Environment(\.modelContext) private var modelContext
    @Query private var stocks: [IngredientStock]

    @StateObject var viewModel: MatchViewModel

    var body: some View {
        ZStack {
            Color.lunchyBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                headerLogo

                if viewModel.matches.isEmpty {
                    VStack(spacing: 16) {
                        Text("Aquí están tus match!")
                            .font(.system(size: 24, weight: .bold))
                            .padding(.top, 20)

                        Text("Aún no hay recetas con tus ingredientes.\nActualiza tus cantidades en la pestaña de Ingredientes.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    Spacer()
                } else {
                    Text("Aquí están tus match!")
                        .font(.system(size: 24, weight: .bold))
                        .padding(.top, 20)

                    TabView {
                        ForEach(viewModel.matches) { match in
                            matchCard(match)
                        }
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .frame(height: 520)

                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.updateMatches(stocks: stocks)
        }
        .onChange(of: stocks) {
            viewModel.updateMatches(stocks: stocks)
        }
        .navigationBarHidden(true)
    }

    private var headerLogo: some View {
        ZStack {
            Color.lunchyLightBlue
                .ignoresSafeArea(edges: .top)

            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 25, weight: .semibold))
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

    private func matchCard(_ match: MatchViewModel.MatchRecipe) -> some View {
        VStack(spacing: 12) {
            Image(viewModel.imageName(for: match.recipe.tipo))
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)

            Text(match.recipe.nombre)
                .font(.system(size: 22, weight: .bold))

            VStack(spacing: 12) {
                ForEach(match.ingredientes) { ing in
                    HStack {
                        Text(ing.nombre)
                        Spacer()
                        Text("\(viewModel.formatted(ing.cantidad)) \(ing.unidad)")
                    }
                    .font(.system(size: 16))

                    if ing.id != match.ingredientes.last?.id {
                        Divider()
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(24)
        }
        .padding(.horizontal, 24)
        .padding(.top, 0)
    }
}
