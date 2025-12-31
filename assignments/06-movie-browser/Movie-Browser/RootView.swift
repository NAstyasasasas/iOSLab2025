//
//  RootView.swift
//  Movie-Browser
//
//  Created by Анастасия on 31.12.2025.
//

import SwiftUI

struct RootView: View {
    @Bindable var viewModel: MoviesViewModel
    
    var body: some View {
        TabView {
            MoviesListView(viewModel: viewModel)
                .tabItem {
                    Label("Base", systemImage: "1.circle")
                }
            
            PathMoviesListView(viewModel: viewModel)
                .tabItem {
                    Label("Plus", systemImage: "2.circle")
                }
        }
    }
}
