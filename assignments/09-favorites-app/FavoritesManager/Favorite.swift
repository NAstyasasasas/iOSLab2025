//
//  Favorite.swift
//  FavoritesManager
//
//  Created by Анастасия on 31.12.2025.
//

import Foundation

struct Favorite: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let category: String
    let notes: String?
    let createdAt: Date
    
    init(id: UUID = UUID(), title: String, category: String, notes: String? = nil, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.category = category
        self.notes = notes
        self.createdAt = createdAt
    }
}
