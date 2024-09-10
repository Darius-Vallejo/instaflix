//
//  HomeViewBuilder.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 9/09/24.
//

import SwiftUI

/// Builder Factory
struct HomeViewBuilder {

    /// Call this function if you want to use without local storage
    static func buildWithoutLocalStorage() -> some View {
        let moviesRepository = MoviesRestRepository()
        let seriesRepository = SeriesRestRepository()
        let genreUseCase = FindGenreUseCase(moviesRepo: moviesRepository, series: seriesRepository)
        let filterByUserCase = FindByFilterContentUseCase(moviesRepo: moviesRepository, series: seriesRepository)

        let viewModel: HomeViewModel = .init(genreUseCase: genreUseCase,
                                             filterByUserCase: filterByUserCase)
        return HomeView(viewModel: viewModel)
    }

    /// Call this function if you want to use the app with local storage
    static func buildWithLocalStorage() -> some View {
        let moviesRepository = MoviesRestRepository()
        let seriesRepository = SeriesRestRepository()
        let monitor = NetworkMonitor.shared
        let moviesLocalStorage = MediaCoreDataRepository(type: .movie)
        let seriesLocalStorage = MediaCoreDataRepository(type: .serie)
        let mediatorForMovies = SynchronizationMediator(moviesRepo: moviesRepository,
                                                        seriesRepo: seriesRepository,
                                                        networkMonitor: monitor,
                                                        localMoviesStorage: moviesLocalStorage,
                                                        localSeriesStorage: seriesLocalStorage,
                                                        type: .movie)

        let mediatorForSeries = SynchronizationMediator(moviesRepo: moviesRepository,
                                                        seriesRepo: seriesRepository,
                                                        networkMonitor: monitor,
                                                        localMoviesStorage: moviesLocalStorage,
                                                        localSeriesStorage: seriesLocalStorage,
                                                        type: .serie)

        let genreUseCase = FindGenreUseCase(moviesRepo: mediatorForMovies, series: mediatorForSeries)
        let filterByUserCase = FindByFilterContentUseCase(moviesRepo: mediatorForMovies, series: mediatorForSeries)

        let viewModel: HomeViewModel = .init(genreUseCase: genreUseCase,
                                             filterByUserCase: filterByUserCase)
        return HomeView(viewModel: viewModel)
    }
}
