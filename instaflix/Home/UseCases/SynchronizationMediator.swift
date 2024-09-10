//
//  SynchronizationMediator.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 9/09/24.
//

import Foundation
import Combine

/// Mediator dessign pattern implementation
actor SynchronizationMediator: MediaRepositoryProtocol {
    
    private var moviesRepo: MediaRepositoryProtocol
    private var seriesRepo: MediaRepositoryProtocol
    private let networkMonitor: NetworkMonitor
    private let localMoviesStorage: LocalDataPersistence
    private let localSeriesStorage: LocalDataPersistence
    private var isNetworkAvailable: Bool = false
    private var cancellable = Set<AnyCancellable>()
    private var type: MediaSection.TypeSection

    private var localRepo: LocalDataPersistence {
        switch type {
        case .movie:
            return localMoviesStorage
        case .serie:
            return localSeriesStorage
        }
    }

    private var remoteAPIRepo: MediaRepositoryProtocol {
        switch type {
        case .movie:
            return moviesRepo
        case .serie:
            return seriesRepo
        }
    }


    init(moviesRepo: MediaRepositoryProtocol,
         seriesRepo: MediaRepositoryProtocol,
         networkMonitor: NetworkMonitor,
         localMoviesStorage: LocalDataPersistence,
         localSeriesStorage: LocalDataPersistence,
         type: MediaSection.TypeSection) {
        self.moviesRepo = moviesRepo
        self.seriesRepo = seriesRepo
        self.networkMonitor = networkMonitor
        self.localMoviesStorage = localMoviesStorage
        self.localSeriesStorage = localSeriesStorage
        self.type = type
        isNetworkAvailable = networkMonitor.networkStatusPublisher.value
    }

    func fetchGenres() async throws -> [MediaSection] {
        if isNetworkAvailable {
            let genres = try await remoteAPIRepo.fetchGenres()
            await localRepo.deleteMedia(bySections: genres)
            localRepo.saveMovieList(genres, isGenre: true)
            return genres
        }

        return try await localRepo.fetchGenres()
    }
    
    func fetchByFilter(category: CustomFilterCategory) async throws -> MediaSection {
        if isNetworkAvailable {
            let categoryList = try await remoteAPIRepo.fetchByFilter(category: category)
            await localRepo.deleteMedia(bySections: [categoryList])
            localRepo.saveMovieList(categoryList, isGenre: false)
            return categoryList
        }

        return try await localRepo.fetchByFilter(category: category)
    }

    func resetAllInfoIfNeeded() async {
        if isNetworkAvailable {
            await localRepo.resetAllInfoIfNeeded()
        }
    }

    func subscribeToChanges() {
        networkMonitor
            .networkStatusPublisher
            .sink { isNetworkAvailable in
                self.isNetworkAvailable = isNetworkAvailable
            }
            .store(in: &cancellable)
    }

}
