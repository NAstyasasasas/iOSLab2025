//
//  UsersCache.swift
//  MyProject
//
//  Created by Анастасия
//

import Foundation

actor UsersCache {
    private var cache: [Int: User] = [:]
    private var pendingTasks: [Int: Task<User?, Never>] = [:]
    
    func get(_ id: Int) -> User? {
        return cache[id]
    }
    
    func save(_ user: User) {
        cache[user.id] = user
    }
    
    func saveAll(_ users: [User]) {
        for user in users {
            cache[user.id] = user
        }
    }
    
    func getUser(id: Int, fetcher: @escaping () async throws -> User?) async throws -> User? {
        if let cached = cache[id] {
            return cached
        }
        
        if let pending = pendingTasks[id] {
            return await pending.value
        }
        
        let task = Task<User?, Never> {
            do {
                let user = try await fetcher()
                if let user = user {
                    save(user)
                }
                pendingTasks[id] = nil
                return user
            } catch {
                pendingTasks[id] = nil
                return nil
            }
        }
        
        pendingTasks[id] = task
        return await task.value
    }
    
    func cancelAllTasks() {
        for (_, task) in pendingTasks {
            task.cancel()
        }
        pendingTasks.removeAll()
    }
}
