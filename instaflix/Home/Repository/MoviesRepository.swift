//
//  MoviesRepository.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 6/09/24.
//

import Foundation

protocol MediaRepositoryProtocol {
    func resetAllInfoIfNeeded() async
    func fetchGenres() async throws -> [MediaSection]
    func fetchByFilter(category: CustomFilterCategory) async throws -> MediaSection
}

extension MediaRepositoryProtocol {
    /// optional implementation
    func resetAllInfoIfNeeded() async {}
}
