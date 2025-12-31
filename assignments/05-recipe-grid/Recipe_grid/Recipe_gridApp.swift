//
//  Recipe_gridApp.swift
//  Recipe_grid
//
//  Created by Анастасия on 31.12.2025.
//

import SwiftUI

@main
struct Recipe_gridApp: App {
    @State var viewModel = RecipesViewModel(recipeService: MockRecipeService())
    
    var body: some Scene {
        WindowGroup {
            RecipesView(viewModel: viewModel)
        }
    }
}
