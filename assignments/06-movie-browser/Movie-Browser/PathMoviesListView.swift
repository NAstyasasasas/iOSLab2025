//
//  PathMoviesListView.swift
//  Movie-Browser
//
//  Created by Анастасия on 30.12.2025.
//

import SwiftUI

struct PathMoviesListView: View {
    @Bindable var viewModel: MoviesViewModel
    @State private var path = NavigationPath()
    @State private var showingAddMovie = false
    @State private var sortByYear = false
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Поиск по названию...", text: $viewModel.searchText)
                    }
                }
                
                Section {
                    let displayMovies = sortByYear ?
                        viewModel.sortedByYearMovies :
                        viewModel.sortedMovies
                    
                    ForEach(displayMovies) { movie in
                        NavigationLink(value: movie) {
                            MovieRowView(movie: movie)
                        }
                    }
                    .onDelete { indexSet in
                        deleteMovies(at: indexSet, displayMovies: displayMovies)
                    }
                } header: {
                    HStack {
                        Text("Фильмы (\(viewModel.filteredMovies.count))")
                        Spacer()
                        Button {
                            sortByYear.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "arrow.up.arrow.down")
                                Text(sortByYear ? "По году" : "По названию")
                            }
                            .font(.caption)
                        }
                    }
                }
            }
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: binding(for: movie))
                    .onDisappear {
                        viewModel.updateMovie(movie)
                    }
            }
            .navigationTitle("Plus: NavigationPath")
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
    
    private func deleteMovies(at indexSet: IndexSet, displayMovies: [Movie]) {
        for index in indexSet {
            if index < displayMovies.count {
                let movie = displayMovies[index]
                if let originalIndex = viewModel.movies.firstIndex(where: { $0.id == movie.id }) {
                    viewModel.movies.remove(at: originalIndex)
                }
            }
        }
    }
    
    private func binding(for movie: Movie) -> Binding<Movie> {
        Binding {
            viewModel.movies.first(where: { $0.id == movie.id }) ?? movie
        } set: { newValue in
            if let idx = viewModel.movies.firstIndex(where: { $0.id == movie.id }) {
                viewModel.movies[idx] = newValue
            }
        }
    }
}
