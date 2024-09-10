//
//  MoviesRestRepository.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 8/09/24.
//

import Foundation

actor MoviesRestRepository: MediaRepositoryProtocol {

    var services: ServicesProcol
    init(services: ServicesProcol = Services.shared) {
        self.services = services
    }

    func fetchByFilter(category: CustomFilterCategory) async throws -> MediaSection {
        let serie = try await self.services.fetch(endPoint: MediaEndpoint.movieWithFilter(MediaByCategoryParam.createForCategory(category, page: 1)), MovieListDTO.self)
        let list: SerieListTitleDTO = .init(id: category.idFromType(aditionalID: CustomFilterCategory.MediaIdType.movie.rawValue),
                                            name: category.nameSectionFromType())
        return MovieListDomainMapper(list: list).mapValue(response: serie)
    }

    func fetchGenres() async throws -> [MediaSection] {
        let genresList = try await services.fetch(endPoint: MediaEndpoint.movieGenres, GenreListDTO.self)
        typealias MovieList = (GenreDTO, MovieListDTO)

        let genres = try await withThrowingTaskGroup(of: MovieList.self) { group -> [MovieList] in
            for genre in Array(genresList.genres).sorted(by: { $0.id < $1.id })[0..<2]{
                group.addTask {
                    let movie = try await self.services.fetch(endPoint: MediaEndpoint.movieWithFilter(MediaWithGenreParam(withGenres: genre.id, page: 1)), MovieListDTO.self)
                    return (genre, movie)
                }
            }

            var results: [MovieList] = []

            for try await movieList in group {
                results.append(movieList)
            }
            return results
        }

        return genres.map { (genre, list) in
            MovieListDomainMapper(list: genre).mapValue(response: list)
        }
    }
}
