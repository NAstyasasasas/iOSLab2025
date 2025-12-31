//
//  MovieRowView.swift
//  Movie-Browser
//
//  Created by Анастасия on 30.12.2025.
//

import SwiftUI

struct MovieRowView: View {
    let movie: Movie
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "film")
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    Text(movie.genre)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                    
                    Text("\(movie.releaseYear)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(movie.description)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
        .animation(.easeInOut(duration: 0.3), value: movie)
    }
}
