//
//  FindGenreUseCase.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 6/09/24.
//

import Foundation


protocol FindGenreUseCaseProtocol {
    func execute() async throws -> [MediaSection]
}

struct FindGenreUseCase: FindGenreUseCaseProtocol {

    private var moviesRepo: MediaRepositoryProtocol
    private var seriesRepo: MediaRepositoryProtocol

    init(moviesRepo: MediaRepositoryProtocol, series: MediaRepositoryProtocol) {
        self.moviesRepo = moviesRepo
        self.seriesRepo = series
    }

    func execute() async throws -> [MediaSection] {
        await moviesRepo.resetAllInfoIfNeeded()
        let series = try await moviesRepo.fetchGenres()
        let movies = try await seriesRepo.fetchGenres()
        let sections = series + movies
        return sections
    }
}

