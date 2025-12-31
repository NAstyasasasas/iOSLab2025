//
//  CategoryFilterView.swift
//  Recipe-grid
//
//  Created by Анастасия on 30.12.2025.
//

import SwiftUI

struct CategoryFilterView: View {
    @Binding var selectedCategory: String?
    let categories: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Button {
                    selectedCategory = nil
                } label: {
                    Text("All")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedCategory == nil ? .blue : .gray.opacity(0.2))
                        .foregroundColor(selectedCategory == nil ? .white : .primary)
                        .clipShape(Capsule())
                }
                
                ForEach(categories, id: \.self) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        Text(category)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedCategory == category ? .blue : .gray.opacity(0.2))
                            .foregroundColor(selectedCategory == category ? .white : .primary)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
