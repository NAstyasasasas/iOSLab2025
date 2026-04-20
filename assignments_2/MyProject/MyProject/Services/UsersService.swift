//
//  UsersService.swift
//  MyProject
//
//  Created by Анастасия
//

import Foundation

protocol UsersService {
    func fetchUsers() async throws -> [User]
}

class RealUsersService: UsersService {
    func fetchUsers() async throws -> [User] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let jsonUsers = try JSONDecoder().decode([JSONUser].self, from: data)
        
        return jsonUsers.enumerated().map { index, user in
            User(
                id: user.id,
                name: user.name,
                email: user.email,
                username: user.username,
                avatarURL: "https://i.pravatar.cc/150?img=\(index + 1)"
            )
        }
    }
}

class MockUsersService: UsersService {
    func fetchUsers() async throws -> [User] {
        print("🔵 MockUsersService: ВЫЗВАН, возвращаю 1 пользователя")
        return [
            User(id: 1, name: "Тест", email: "test@test.com", username: "test", avatarURL: nil)
        ]
    }
}

struct JSONUser: Codable {
    let id: Int
    let name: String
    let email: String
    let username: String
}
