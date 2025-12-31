//
//  RecipeCardView.swift
//  Recipe_grid
//
//  Created by Анастасия on 31.12.2025.
//

import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    var onDelete: (() -> Void)?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                if recipe.imageName.isEmpty {
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 150, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                } else {
                    Image(recipe.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Text(recipe.title)
                    .font(.headline)
                    .lineLimit(2)
                    .padding(.top, 5)
                
                Text(recipe.category)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 2)
            
            if let onDelete = onDelete {
                Button(action: {
                    onDelete()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                        .background(Circle().fill(.white))
                        .padding(4)
                }
                .offset(x: 5, y: -5)
            }
        }
        .contextMenu {
            if let onDelete = onDelete {
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
}
