//
//  AddRecipeSheet.swift
//  Recipe_grid
//
//  Created by Анастасия on 31.12.2025.
//

import SwiftUI

struct AddRecipeSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var imageName: String = ""
    @State private var summary: String = ""
    @State private var category: String = ""
    @State private var showingAlert = false
    
    var onAdd: (Recipe) -> Void
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basics") {
                    TextField("Title*", text: $title)
                        .autocapitalization(.words)
                    TextField("Image name", text: $imageName)
                        .autocapitalization(.none)
                    TextField("Category", text: $category)
                }
                
                Section("Summary") {
                    TextEditor(text: $summary)
                        .frame(height: 150)
                }
            }
            .navigationTitle(Text("Add Recipe"))
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if isFormValid {
                            onAdd(Recipe(
                                id: UUID(),
                                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                                imageName: imageName,
                                summary: summary,
                                category: category.isEmpty ? "Uncategorized" : category
                            ))
                            dismiss()
                        } else {
                            showingAlert = true
                        }
                    }
                    .disabled(!isFormValid)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Title Required", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a title for your recipe.")
            }
        }
    }
}
