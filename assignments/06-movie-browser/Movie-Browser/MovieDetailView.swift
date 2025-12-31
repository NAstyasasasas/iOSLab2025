//
//  MovieDetailView.swift
//  Movie-Browser
//
//  Created by Анастасия on 30.12.2025.
//

import SwiftUI

struct MovieDetailView: View {
    @Binding var movie: Movie
    @Environment(\.dismiss)
    private var dismiss
    
    var body: some View {
        Form {
            Section("Информация о фильме") {
                HStack {
                    Image(systemName: "film")
                        .font(.title)
                        .foregroundColor(.blue)
                    
                    TextField("Название", text: $movie.title)
                        .font(.title2.bold())
                }
                
                Picker("Жанр", selection: $movie.genre) {
                    Text("Боевик").tag("Боевик")
                    Text("Комедия").tag("Комедия")
                    Text("Драма").tag("Драма")
                    Text("Фантастика").tag("Фантастика")
                    Text("Ужасы").tag("Ужасы")
                    Text("Романтика").tag("Романтика")
                    Text("Мультфильм").tag("Мультфильм")
                }
                .pickerStyle(.menu)
                
                Stepper("Год выпуска: \(movie.releaseYear)", value: $movie.releaseYear, in: 1900...2025)
            }
            
            Section("Описание") {
                TextEditor(text: $movie.description)
                    .frame(minHeight: 100)
            }
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("ID фильма:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(movie.id.uuidString)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Редактировать фильм")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Готово") {
                    dismiss()
                }
                .bold()
            }
        }
    }
}
