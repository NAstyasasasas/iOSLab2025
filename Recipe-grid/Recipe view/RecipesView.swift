//
//  RecipesView.swift
//  Recipe-grid
//
//  Created by Анастасия on 29.12.2025.
//

import SwiftUI

struct RecipesView: View {
    @Bindable var viewModel: RecipesViewModel
    
    @State private var showAdd = false
    @Namespace private var namespace
    
    private var grid: [GridItem] {
        let columns = [
            GridItem(.adaptive(minimum: 150), spacing: 16)
        ]
        return columns
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if !viewModel.categories.isEmpty {
                        CategoryFilterView(
                            selectedCategory: $viewModel.selectedCategory,
                            categories: viewModel.categories
                        )
                        .padding(.top, 8)
                    }
                    
                    Picker("Sort by", selection: $viewModel.sortOption) {
                        Text("Newest").tag(RecipesViewModel.SortOption.dateAdded)
                        Text("Title").tag(RecipesViewModel.SortOption.title)
                        Text("Category").tag(RecipesViewModel.SortOption.category)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    bodyContent
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Recipes")
            .searchable(text: $viewModel.searchText, prompt: "Search recipes...")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAdd.toggle()
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddRecipeSheet { recipe in
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        viewModel.add(recipe)
                    }
                }
            }
            .task {
                await viewModel.loadRecipes()
            }
        }
    }
    
    @ViewBuilder
    private var bodyContent: some View {
        switch viewModel.screenState {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: 150)
                .scaleEffect(1.5)
            
        case .error(let errorMessage):
            ErrorStateView(message: errorMessage)
            
        case .empty:
            EmptyStateView(
                title: "No recipes found",
                subtitle: viewModel.searchText.isEmpty
                    ? "Tap + to add your first recipe!"
                    : "Try searching for something else"
            )
            
        case .content(let recipes):
            LazyVGrid(columns: grid, spacing: 20) {
                ForEach(Array(recipes.enumerated()), id: \.element.id) { index, recipe in
                    RecipeCardView(recipe: recipe) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            viewModel.remove(recipe)
                        }
                    }
                    .matchedGeometryEffect(id: recipe.id, in: namespace, isSource: false)
                    .transition(
                        .asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        )
                    )
                }
            }
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: recipes)
        }
    }
}
