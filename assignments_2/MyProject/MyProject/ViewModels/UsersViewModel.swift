//
//  UsersViewModel.swift
//  MyProject
//
//  Created by Анастасия
//

import Foundation
import SwiftUI
import Combine

class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private let service: UsersService
    private let cache = UsersCache()
    private var currentTask: Task<Void, Never>?
    
    init() {
        self.service = RealUsersService()
        loadUsers()
    }
    
    init(service: UsersService) {
        self.service = service
        loadUsers()
    }
    
    func loadUsers() {
        currentTask?.cancel()
        
        currentTask = Task {
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = ""
            }
            
            do {
                let fetchedUsers = try await service.fetchUsers()
                await cache.saveAll(fetchedUsers)
                
                await MainActor.run {
                    self.users = fetchedUsers
                    self.isLoading = false
                }
            } catch {
                if !Task.isCancelled {
                    await MainActor.run {
                        self.errorMessage = error.localizedDescription
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    func loadMultipleUsers(ids: [Int]) async -> [User] {
        return await withTaskGroup(of: User?.self) { group in
            for id in ids {
                group.addTask {
                    return await self.cache.get(id)
                }
            }
            
            var results: [User] = []
            for await user in group {
                if let user = user {
                    results.append(user)
                }
            }
            return results
        }
    }
    
    func cancelLoading() {
        currentTask?.cancel()
    }
    func loadUsersForTest() async -> [User] {
        do {
            let fetchedUsers = try await service.fetchUsers()
            await cache.saveAll(fetchedUsers)
            await MainActor.run {
                self.users = fetchedUsers
                self.isLoading = false
            }
            return fetchedUsers
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
            return []
        }
    }
}
