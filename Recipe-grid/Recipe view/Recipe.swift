//
//  Recipe.swift
//  Recipe-grid
//
//  Created by Анастасия on 29.12.2025.
//

import Foundation

struct Recipe: Identifiable, Hashable {
    let id: UUID
    let title: String
    let imageName: String
    let summary: String
    let category: String
    
    init(id: UUID = UUID(), title: String, imageName: String, summary: String, category: String) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.summary = summary
        self.category = category
    }
}
