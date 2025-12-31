//
//  FavoritesListView.swift
//  FavoritesManager
//
//  Created by Анастасия on 31.12.2025.
//

import SwiftUI

struct FavoritesListView: View {
    @Bindable var viewModel: FavoritesViewModel
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationStack {
            VStack {
                filterPanel
                
                if viewModel.isLoading {
                    ProgressView("Загрузка...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.filteredFavorites.isEmpty {
                    emptyView
                } else {
                    listView
                }
                
                Button {
                    showingAddSheet.toggle()
                } label: {
                    Label("Добавить в избранное", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .sheet(isPresented: $showingAddSheet) {
                AddFavoriteView(viewModel: viewModel)
            }
            .navigationTitle("Избранное")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Очистить всё", role: .destructive) {
                        Task { await viewModel.clearAll() }
                    }
                    .disabled(viewModel.favorites.isEmpty)
                }
            }
        }
    }
    
    private var filterPanel: some View {
        VStack(spacing: 12) {
            Picker("Фильтр", selection: $viewModel.filterOption) {
                ForEach(FavoritesViewModel.FilterOption.allCases, id: \.self) { option in
                    Text(option.title).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .onChange(of: viewModel.filterOption) {
                viewModel.applyFilter()
            }
            
            if viewModel.filterOption == .byLetter {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.letters, id: \.self) { letter in
                            Button(letter) {
                                viewModel.selectedLetter = letter
                                viewModel.applyFilter()
                            }
                            .buttonStyle(.bordered)
                            .background(viewModel.selectedLetter == letter ? .blue : .clear)
                            .foregroundColor(viewModel.selectedLetter == letter ? .white : .blue)
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            if viewModel.filterOption == .byCategory && !viewModel.allCategories.isEmpty {
                Picker("Категория", selection: $viewModel.selectedCategory) {
                    ForEach(viewModel.allCategories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)
                .onChange(of: viewModel.selectedCategory) {
                    viewModel.applyFilter()
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "star.slash")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("Нет избранного")
                .font(.headline)
            Text("Добавьте что-нибудь с помощью формы ниже")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var listView: some View {
        List {
            ForEach(viewModel.filteredFavorites) { favorite in
                FavoriteRowView(favorite: favorite)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            if let index = viewModel.favorites.firstIndex(of: favorite) {
                                Task {
                                    await viewModel.removeFavorite(at: IndexSet(integer: index))
                                }
                            }
                        } label: {
                            Label("Удалить", systemImage: "trash")
                        }
                    }
            }
            .onDelete { offsets in
                Task {
                    await viewModel.removeFavorite(at: offsets)
                }
            }
        }
        .animation(.default, value: viewModel.filteredFavorites)
        .refreshable {
            await viewModel.loadFavorites()
        }
    }
}

struct FavoriteRowView: View {
    let favorite: Favorite
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(favorite.title)
                    .font(.headline)
                Spacer()
                Text(favorite.category)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Capsule())
            }
            
            if let notes = favorite.notes, !notes.isEmpty {
                Text(notes)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Text("Добавлено: \(formattedDate)")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
        .transition(.opacity.combined(with: .scale))
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: favorite.createdAt)
    }
}
