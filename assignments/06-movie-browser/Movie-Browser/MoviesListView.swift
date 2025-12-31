//
//  MoviesListView.swift
//  Movie-Browser
//
//  Created by Анастасия on 30.12.2025.
//

import SwiftUI

struct MoviesListView: View {
    @Bindable var viewModel: MoviesViewModel
    @State private var showingAddMovie = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($viewModel.movies) { $movie in
                    NavigationLink {
                        MovieDetailView(movie: $movie)
                            .onDisappear {
                                viewModel.updateMovie(movie)
                            }
                    } label: {
                        MovieRowView(movie: movie)
                    }
                }
                .onDelete(perform: viewModel.removeMovie)
                
                if viewModel.movies.isEmpty {
                    Text("Нет фильмов")
                        .foregroundColor(.secondary)
                        .italic()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Base: Обычная навигация")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddMovie = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddMovie) {
                AddMovieView(viewModel: viewModel)
            }
        }
    }
}
