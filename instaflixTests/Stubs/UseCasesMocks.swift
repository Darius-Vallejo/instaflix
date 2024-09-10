//
//  UseCasesMocks.swift
//  instaflixTests
//
//  Created by Dario Fernando Vallejo Posada on 10/09/24.
//

import XCTest
@testable import instaflix

// Mock FindGenreUseCaseProtocol
class MockFindGenreUseCase: FindGenreUseCaseProtocol {
    var shouldThrowError = false

    func execute() async throws -> [MediaSection] {
        if shouldThrowError {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        return [MediaSection(id: 1, title: "Test Genre", page: 1, type: .movie, list: [])]
    }
}

// Mock FindByFilterContentUseCaseProtocol
class MockFindByFilterContentUseCase: FindByFilterContentUseCaseProtocol {
    var shouldThrowError = false

    func execute(category: CustomFilterCategory...) async throws -> [MediaSection] {
        if shouldThrowError {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        return [MediaSection(id: 2, title: "Test Category", page: 1, type: .serie, list: [])]
    }
}
