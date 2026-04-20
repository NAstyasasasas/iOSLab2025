//
//  UsersListView.swift
//  MyProject
//
//  Created by Анастасия
//

import SwiftUI

struct CustomUserCard: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: user.avatarURL ?? "")) { phase in
                if let image = phase.image {
                    image.resizable()
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            ProgressView()
                                .scaleEffect(0.7)
                        )
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 5) {
                Text(user.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("@\(user.username)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(user.email)
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
}

struct UsersListView: View {
    @StateObject private var viewModel = UsersViewModel()
    @State private var selectedUser: User?
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Загрузка...")
                } else if !viewModel.errorMessage.isEmpty {
                    VStack {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                        Button("Повторить") {
                            viewModel.loadUsers()
                        }
                    }
                } else {
                    List(viewModel.users) { user in
                        Button {
                            selectedUser = user
                        } label: {
                            CustomUserCard(user: user)
                        }
                        .foregroundColor(.primary)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Пользователи")
            .sheet(item: $selectedUser) { user in
                ProfileControllerWrapper(user: user)
            }
        }
    }
}
