//
//  FavoritesStore.swift
//  FavoritesManager
//
//  Created by Анастасия on 31.12.2025.
//

import Foundation

actor FavoritesStore {
    private let fileName = "favorites.json"
    private var favorites: [Favorite] = []
    
    private var fileURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent(fileName)
    }
    
    func load() async throws -> [Favorite] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("Файла нет, возвращаем пустой массив")
            return []
        }
        
        let data = try Data(contentsOf: fileURL)
        let decoded = try JSONDecoder().decode([Favorite].self, from: data)
        self.favorites = decoded
        return decoded
    }
    
    func save(_ favorites: [Favorite]) async throws {
        self.favorites = favorites
        let data = try JSONEncoder().encode(favorites)
        try data.write(to: fileURL, options: .atomic)
        print("Сохранено в файл: \(fileURL.path)")
    }
    
    func getAll() -> [Favorite] {
        return favorites
    }
}
