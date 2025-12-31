//
//  FavoritesViewModel.swift
//  FavoritesManager
//
//  Created by Анастасия on 31.12.2025.
//

import Foundation
import SwiftUI

@Observable
final class FavoritesViewModel: ObservableObject {
    enum FilterOption: String, CaseIterable {
        case all = "Все"
        case byLetter = "По букве"
        case byCategory = "По категории"
        
        var title: String {
            switch self {
            case .all: return "Все"
            case .byLetter: return "По букве"
            case .byCategory: return "По категории"
            }
        }
    }
    
    private let store = FavoritesStore()
    var favorites: [Favorite] = []
    var filteredFavorites: [Favorite] = []
    var isLoading = false
    var errorMessage: String?
    
    var filterOption: FilterOption = .all
    var selectedLetter: String = "A"
    var selectedCategory: String = "Movies"
    
    var newTitle = ""
    var newCategory = ""
    var newNotes = ""
    
    var allCategories: [String] {
        Set(favorites.map { $0.category }).sorted()
    }
    
    var letters: [String] {
        let russianAlphabet = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"
        return russianAlphabet.map(String.init)
    }
    
    init() {
        Task { await loadFavorites() }
    }
    
    @MainActor
    func loadFavorites() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            favorites = try await store.load()
            applyFilter()
            errorMessage = nil
        } catch {
            errorMessage = "Не удалось загрузить избранное: \(error.localizedDescription)"
            favorites = []
        }
    }
    
    @MainActor
    func addFavorite() async {
        guard !newTitle.isEmpty else { return }
        let favorite = Favorite(title: newTitle, category: newCategory, notes: newNotes.isEmpty ? nil : newNotes)
        
        favorites.insert(favorite, at: 0)
        applyFilter()
        
        newTitle = ""
        newCategory = ""
        newNotes = ""
        
        do {
            try await store.save(favorites)
        } catch {
            errorMessage = "Не удалось сохранить: \(error.localizedDescription)"
        }
    }
    
    @MainActor
    func removeFavorite(at offsets: IndexSet) async {
        favorites.remove(atOffsets: offsets)
        applyFilter()
        
        do {
            try await store.save(favorites)
        } catch {
            errorMessage = "Ошибка при удалении: \(error.localizedDescription)"
        }
    }
    
    @MainActor
    func clearAll() async {
        favorites.removeAll()
        filteredFavorites.removeAll()
        
        do {
            try await store.save([])
        } catch {
            errorMessage = "Не удалось очистить: \(error.localizedDescription)"
        }
    }
    
    func applyFilter() {
        var result = favorites
        
        result.sort { $0.createdAt > $1.createdAt }
        
        if filterOption == .byLetter && !selectedLetter.isEmpty {
            result = result.filter { $0.title.uppercased().hasPrefix(selectedLetter.uppercased()) }
        }
        
        if filterOption == .byCategory && !selectedCategory.isEmpty {
            result = result.filter { $0.category == selectedCategory }
        }
        
        filteredFavorites = result
    }
}
