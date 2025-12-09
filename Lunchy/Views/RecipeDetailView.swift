//
//  RecipeDetailView.swift
//  Lunchy
//
//  Created by Paulina Vara on 08/12/25.
//

import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: RecipeDetailViewModel

    var body: some View {
        ZStack {
            Color.lunchyBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                headerBar

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text(viewModel.recipe.nombre)
                            .font(.system(size: 24, weight: .bold))

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
    }

    // MARK: - Header

    private var headerBar: some View {
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

    // MARK: - Cards

    private var timeCard: some View {
        VStack(spacing: 0) {
            timeRow(label: "Preparación", value: "\(viewModel.recipe.tiempo_preparacion_min) minutos")

            Divider()
                .padding(.horizontal, 4)
                .padding(.vertical, 4)

            timeRow(label: "Cocción", value: "\(viewModel.recipe.tiempo_coccion_min) minutos")

            Divider()
                .padding(.horizontal, 4)
                .padding(.vertical, 4)

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
        .padding(.vertical, 12)   // espacio entre tiempos
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
                .padding(.vertical, 12)   // ← antes 6, AHORA igual al tab de ingredientes

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
                    .padding(.vertical, 12)  // espacio entre pasos

                if step != viewModel.recipe.pasos.last {
                    Divider()
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white)
        .cornerRadius(18)
    }
}

