//
//  AddFavoriteView.swift
//  FavoritesManager
//
//  Created by Анастасия on 31.12.2025.
//

import SwiftUI

struct AddFavoriteView: View {
    @Bindable var viewModel: FavoritesViewModel
    @Environment(\.dismiss)
    private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Основное") {
                    TextField("Название", text: $viewModel.newTitle)
                    TextField("Категория (например, Movies)", text: $viewModel.newCategory)
                }
                
                Section("Заметки (необязательно)") {
                    TextEditor(text: $viewModel.newNotes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Новое избранное")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") {
                        Task {
                            await viewModel.addFavorite()
                            dismiss()
                        }
                    }
                    .disabled(viewModel.newTitle.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
            }
        }
    }
}
