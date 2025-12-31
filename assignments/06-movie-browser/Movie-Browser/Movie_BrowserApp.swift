//
//  Movie_BrowserApp.swift
//  Movie-Browser
//
//  Created by Анастасия on 30.12.2025.
//

import SwiftUI

@main
struct Movie_BrowserApp: App {
    @State private var viewModel = MoviesViewModel()
        
    var body: some Scene {
        WindowGroup {
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
}
