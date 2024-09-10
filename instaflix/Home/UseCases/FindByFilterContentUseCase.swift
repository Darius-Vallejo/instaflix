//
//  FindLanguageContentUseCase.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 8/09/24.
//

import Foundation

protocol FindByFilterContentUseCaseProtocol {
    func execute(category: CustomFilterCategory...) async throws -> [MediaSection]
}

actor FindByFilterContentUseCase: FindByFilterContentUseCaseProtocol {
    private var moviesRepo: MediaRepositoryProtocol
    private var seriesRepo: MediaRepositoryProtocol

    init(moviesRepo: MediaRepositoryProtocol, series: MediaRepositoryProtocol) {
        self.moviesRepo = moviesRepo
        self.seriesRepo = series
    }

    func execute(category: CustomFilterCategory...) async throws -> [MediaSection] {
        var sections = [MediaSection]()
        let asyncCategories: CustomFilterCategoryAsyncSequence = .init(category)

        try await withThrowingTaskGroup(of: [MediaSection].self) { group in
            for await customCategory in asyncCategories {
                group.addTask {
                    let (movies, series) = try await (
                        self.moviesRepo.fetchByFilter(category: customCategory),
                        self.seriesRepo.fetchByFilter(category: customCategory)
                    )
                    return [series, movies]
                }

                for try await sectionList in group {
                    sections.append(contentsOf: sectionList)
                }
            }
        }

        return sections
    }
}
