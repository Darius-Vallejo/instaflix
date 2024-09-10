//
//  HomeViewModelTests.swift
//  instaflixTests
//
//  Created by Dario Fernando Vallejo Posada on 10/09/24.
//

import XCTest
@testable import instaflix

class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!
    var mockGenreUseCase: MockFindGenreUseCase!
    var mockFilterByUseCase: MockFindByFilterContentUseCase!

    override func setUp() {
        super.setUp()
        mockGenreUseCase = MockFindGenreUseCase()
        mockFilterByUseCase = MockFindByFilterContentUseCase()
        viewModel = HomeViewModel(genreUseCase: mockGenreUseCase, filterByUserCase: mockFilterByUseCase)
    }

    override func tearDown() {
        viewModel = nil
        mockGenreUseCase = nil
        mockFilterByUseCase = nil
        super.tearDown()
    }

    // Test successful data fetching
    @MainActor
    func testFetchAllSuccess() async {
        // When
        await viewModel.fetchAll()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.loadingError)
        XCTAssertEqual(viewModel.sections.count, 2) // 1 for genre, 1 for category
    }

    // Test error when fetching genres
    @MainActor
    func testFetchGendersError() async {
        // Given
        mockGenreUseCase.shouldThrowError = true

        // When
        await viewModel.fetchAll()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.loadingError)
        XCTAssertEqual(viewModel.sections.count, 1) // Only categories should be fetched
    }

    // Test error when fetching genres and categories
    @MainActor
    func testFetchAllError() async {
        // Given
        mockGenreUseCase.shouldThrowError = true
        mockFilterByUseCase.shouldThrowError = true

        // When
        await viewModel.fetchAll()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.loadingError)
        XCTAssertEqual(viewModel.sections.count, 0) // Only categories should be fetched
    }


    // Test error when fetching categories
    @MainActor
    func testFetchManyCategoriesError() async {
        // Given
        mockFilterByUseCase.shouldThrowError = true

        // When
        await viewModel.fetchAll()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.loadingError)
        XCTAssertEqual(viewModel.sections.count, 1) // Only genres should be fetched
    }

    // Test that `isLoading` is true while fetching
    @MainActor
    func testIsLoadingWhileFetching() async {
        // Given
        mockGenreUseCase.shouldThrowError = false
        mockFilterByUseCase.shouldThrowError = false

        // When
        let task = Task {
            await viewModel.fetchAll()
        }

        // Then
        XCTAssertTrue(viewModel.isLoading)

        // Wait for the task to finish
        await task.value
    }
}
