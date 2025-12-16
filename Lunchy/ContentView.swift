//
//  ContentView.swift
//  Lunchy
//
//  Created by Paulina Vara on 08/12/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var filtersVM = FiltersViewModel()

    var body: some View {
        TabView {
            RecipesListView(viewModel: RecipesListViewModel())
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Recetas")
                }

            IngredientsView(viewModel: IngredientsViewModel())
                .tabItem {
                    Image(systemName: "leaf")
                    Text("Ingredientes")
                }
        }
        .environmentObject(filtersVM)
        .accentColor(.lunchyBlue)
    }
}


#Preview {
    ContentView()
}
