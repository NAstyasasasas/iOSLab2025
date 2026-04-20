//
//  UsersViewModelTests.swift
//  MyProjectTests
//

import XCTest
@testable import MyProject

final class UsersViewModelTests: XCTestCase {
    
    func testSuccessfulLoad() async {
        print("🟢 Тест начался")
        let mockService = MockUsersService()
        let viewModel = UsersViewModel(service: mockService)
        
        let users = await viewModel.loadUsersForTest()
        
        print("🟢 Получено пользователей: \(users.count)")
        print("🟢 viewModel.users.count: \(viewModel.users.count)")
        
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(viewModel.users.count, 1)
        XCTAssertTrue(viewModel.errorMessage.isEmpty)
        print("🟢 Тест прошел успешно!")
    }
    
    func testErrorHandling() async {
        let failingService = FailingUsersService()
        let viewModel = UsersViewModel(service: failingService)
        
        _ = await viewModel.loadUsersForTest()
        
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertFalse(viewModel.errorMessage.isEmpty)
    }
}

class FailingUsersService: UsersService {
    func fetchUsers() async throws -> [User] {
        throw NSError(domain: "TestError", code: 404, userInfo: nil)
    }
}
