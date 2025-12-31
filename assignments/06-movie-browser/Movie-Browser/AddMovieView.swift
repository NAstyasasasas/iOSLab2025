//
//  AddMovieView.swift
//  Movie-Browser
//
//  Created by Анастасия on 31.12.2025.
//

import SwiftUI

struct AddMovieView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: MoviesViewModel
    
    @State private var title = ""
    @State private var genre = "Action"
    @State private var description = ""
    @State private var releaseYear = 2024
    
    var body: some View {
        NavigationView {
            Form {
                Section("Детали фильма") {
                    TextField("Название", text: $title)
                    
                    Picker("Жанр", selection: $genre) {
                        Text("Боевик").tag("Боевик")
                        Text("Комедия").tag("Комедия")
                        Text("Драма").tag("Драма")
                        Text("Фантастика").tag("Фантастика")
                        Text("Ужасы").tag("Ужасы")
                        Text("Романтика").tag("Романтика")
                        Text("Мультфильм").tag("Мультфильм")
                    }
                    
                    TextField("Описание", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    
                    Stepper("Год выпуска: \(releaseYear)", value: $releaseYear, in: 1900...2025)
                }
            }
            .navigationTitle("Добавить новый фильм")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        viewModel.addMovie(
                            title: title,
                            genre: genre,
                            description: description,
                            releaseYear: releaseYear
                        )
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .bold()
                }
            }
        }
    }
}
