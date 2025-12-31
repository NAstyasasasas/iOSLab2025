//
//  FavoritesManagerApp.swift
//  FavoritesManager
//
//  Created by Анастасия on 31.12.2025.
//

import SwiftUI

@main
struct FavoritesManagerApp: App {
    @State private var viewModel = FavoritesViewModel()
    
    var body: some Scene {
        WindowGroup {
            FavoritesListView(viewModel: viewModel)
        }
    }
}
