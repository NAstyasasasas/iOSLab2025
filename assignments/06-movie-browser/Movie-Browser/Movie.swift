//
//  Movie.swift
//  Movie-Browser
//
//  Created by Анастасия on 30.12.2025.
//

import Foundation

struct Movie: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var genre: String
    var description: String
    var releaseYear: Int
    
    init(id: UUID = UUID(), title: String, genre: String, description: String, releaseYear: Int) {
        self.id = id
        self.title = title
        self.genre = genre
        self.description = description
        self.releaseYear = releaseYear
    }
}
