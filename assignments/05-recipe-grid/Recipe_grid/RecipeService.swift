//
//  RecipeService.swift
//  Recipe_grid
//
//  Created by Анастасия on 31.12.2025.
//

import Foundation

protocol RecipeService {
    func obtainRecipes() async throws -> [Recipe]
}

struct MockRecipeService: RecipeService {
    func obtainRecipes() async throws -> [Recipe] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return [
            Recipe(id: UUID(),
                  title: "Spaghetti Carbonara",
                  imageName: "pasta",
                  summary: "Classic Italian pasta with eggs, cheese, pancetta, and black pepper",
                  category: "Italian"),
            
            Recipe(id: UUID(),
                  title: "Vegetable Sushi",
                  imageName: "sushi",
                  summary: "Fresh vegetable rolls with avocado, cucumber and carrot",
                  category: "Japanese"),
            
            Recipe(id: UUID(),
                  title: "Margherita Pizza",
                  imageName: "pizza",
                  summary: "Simple pizza with tomato sauce, mozzarella, and basil",
                  category: "Italian"),
            
            Recipe(id: UUID(),
                  title: "Tomato Soup",
                  imageName: "soup",
                  summary: "Creamy tomato soup with herbs",
                  category: "Soup"),
            
            Recipe(id: UUID(),
                  title: "Chocolate Cake",
                  imageName: "cake",
                  summary: "Rich and moist chocolate cake",
                  category: "Dessert"),
            
            Recipe(id: UUID(),
                  title: "Caesar Salad",
                  imageName: "salad",
                  summary: "Fresh romaine lettuce with Caesar dressing",
                  category: "Salad"),
            
            Recipe(id: UUID(),
                  title: "Beef Burger",
                  imageName: "burger",
                  summary: "Juicy beef burger with cheese and vegetables",
                  category: "Fast Food")
        ]
    }
}
