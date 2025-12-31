//
//  RecipesViewModel.swift
//  Recipe_grid
//
//  Created by Анастасия on 31.12.2025.
//

import Foundation

@Observable
final class RecipesViewModel {
    enum ScreenState {
        case loading
        case error(String)
        case empty
        case content([Recipe])
    }
    
    enum SortOption {
        case title
        case category
        case dateAdded
    }
    
    var items: [Recipe] = []
    var isLoading = false
    var errorString: String?
    var searchText: String = ""
    var selectedCategory: String?
    var sortOption: SortOption = .dateAdded
    
    let recipeService: RecipeService
    
    var categories: [String] {
        Array(Set(items.map { $0.category })).sorted()
    }
    
    var filteredItems: [Recipe] {
        var filtered = items
        
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        switch sortOption {
        case .title:
            return filtered.sorted { $0.title < $1.title }
        case .category:
            return filtered.sorted { $0.category < $1.category }
        case .dateAdded:
            return filtered
        }
    }
    
    var screenState: ScreenState {
        if isLoading {
            return .loading
        }
        if let error = errorString {
            return .error(error)
        }
        return filteredItems.isEmpty ? .empty : .content(filteredItems)
    }
    
    init(recipeService: RecipeService) {
        self.recipeService = recipeService
    }
    
    func loadRecipes() async {
        guard items.isEmpty, !isLoading else { return }
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            items = try await recipeService.obtainRecipes()
            errorString = nil
        } catch {
            errorString = "Failed to load recipes"
        }
    }
    
    func add(_ recipe: Recipe) {
        items.insert(recipe, at: 0)
    }
    
    func remove(_ recipe: Recipe) {
        guard let index = items.firstIndex(of: recipe) else { return }
        items.remove(at: index)
    }
}
