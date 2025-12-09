//
//  ContentView.swift
//  Lunchy
//
//  Created by Paulina Vara on 08/12/25.
//

import SwiftUI

struct ContentView: View {
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
        .accentColor(.lunchyBlue)
    }
}


#Preview {
    ContentView()
}
