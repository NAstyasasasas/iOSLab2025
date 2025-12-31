//
//  MovieViewModel.swift
//  Movie-Browser
//
//  Created by Анастасия on 30.12.2025.
//

import Foundation
import Observation

@Observable
final class MoviesViewModel {
    var movies: [Movie] = [
        Movie(
            title: "Начало",
            genre: "Фантастика",
            description: "Вор, крадущий корпоративные секреты через технологию общего доступа к сновидениям.",
            releaseYear: 2010
        ),
        Movie(
            title: "Тёмный рыцарь",
            genre: "Боевик",
            description: "Бэтмен сталкивается с Джокером, криминальным гением.",
            releaseYear: 2008
        ),
        Movie(
            title: "Интерстеллар",
            genre: "Фантастика",
            description: "Команда исследователей путешествует через червоточину.",
            releaseYear: 2014
        ),
    ]
    
    var searchText: String = ""
    
    var filteredMovies: [Movie] {
        if searchText.isEmpty {
            return movies
        } else {
            return movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var sortedMovies: [Movie] {
        filteredMovies.sorted { $0.title < $1.title }
    }
    
    var sortedByYearMovies: [Movie] {
        filteredMovies.sorted { $0.releaseYear > $1.releaseYear }
    }
    
    func addMovie(title: String, genre: String, description: String, releaseYear: Int) {
        let newMovie = Movie(
            title: title,
            genre: genre,
            description: description,
            releaseYear: releaseYear
        )
        movies.insert(newMovie, at: 0)
        saveMovies()
    }
    
    func removeMovie(at offsets: IndexSet) {
        movies.remove(atOffsets: offsets)
        saveMovies()
    }
    
    func updateMovie(_ movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index] = movie
            saveMovies()
        }
    }
    
    private let moviesKey = "savedMovies"
    
    init() {
        loadMovies()
    }
    
    private func saveMovies() {
        if let encoded = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(encoded, forKey: moviesKey)
        }
    }
    
    private func loadMovies() {
        if let savedData = UserDefaults.standard.data(forKey: moviesKey),
           let decodedMovies = try? JSONDecoder().decode([Movie].self, from: savedData) {
            movies = decodedMovies
        }
    }
}
