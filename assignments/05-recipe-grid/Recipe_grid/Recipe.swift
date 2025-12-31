//
//  Recipe.swift
//  Recipe_grid
//
//  Created by Анастасия on 31.12.2025.
//

import Foundation

struct Recipe: Identifiable, Hashable {
    let id: UUID
    let title: String
    let imageName: String
    let summary: String
    let category: String
}
