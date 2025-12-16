//
//  FiltersSheetView.swift
//  Lunchy
//
//  Created by Paulina Vara on 15/12/25.
//

import SwiftUI

struct FiltersSheetView: View {
    @Environment(\.dismiss) private var dismiss

    let current: RecipeFilters
    let onApply: (RecipeFilters) -> Void

    @State private var draft: RecipeFilters

    init(current: RecipeFilters, onApply: @escaping (RecipeFilters) -> Void) {
        self.current = current
        self.onApply = onApply
        _draft = State(initialValue: current)
    }

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal)
                .padding(.top, 25)
                .padding(.bottom, 8)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Tiempo de preparación")
                        .font(.system(size: 20, weight: .bold))

                    HStack {
                        Text("Tiempo máximo (minutos)")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(draft.maxTime)")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(18)

                    Slider(
                        value: Binding(
                            get: { Double(draft.maxTime) },
                            set: { draft.maxTime = Int($0) }
                        ),
                        in: 10...120,
                        step: 5
                    )
                    .tint(.lunchyBlue)
                    .padding(.top, 6)

                    Text("Tipo de platillo")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.top, 6)

                    typesGrid

                    Toggle("Mostrar solo favoritos", isOn: $draft.onlyFavorites)
                        .tint(.lunchyBlue)
                        .padding(.top, 8)

                    Spacer(minLength: 24)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .padding(.top, 16)
        }
        .background(Color.lunchyBackground)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    private var header: some View {
        HStack {
            Button("Cancelar") { dismiss() }
                .foregroundColor(.gray)

            Spacer()

            Text("Filtros")
                .font(.system(size: 22, weight: .bold))

            Spacer()

            Button("Aplicar") {
                onApply(draft)
                dismiss()
            }
            .foregroundColor(.lunchyBlue)
            .font(.system(size: 18, weight: .semibold))
        }
    }

    private var typesGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
            ForEach(RecipeType.allCases) { type in
                typeCheck(type)
            }
        }
    }

    private func typeCheck(_ type: RecipeType) -> some View {
        let isOn = draft.selectedTypes.contains(type)

        return Button {
            if isOn { draft.selectedTypes.remove(type) }
            else { draft.selectedTypes.insert(type) }
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                        .frame(width: 26, height: 26)

                    if isOn {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.lunchyLightBlue)
                            .frame(width: 26, height: 26)

                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                    }
                }

                Text(type.title)
                    .foregroundColor(.black)
                    .font(.system(size: 18))

                Spacer()
            }
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
    }
}

