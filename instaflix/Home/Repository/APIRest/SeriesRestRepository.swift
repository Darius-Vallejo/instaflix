//
//  SeriesRestRepository.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 8/09/24.
//

import Foundation

actor SeriesRestRepository: MediaRepositoryProtocol {

    var services: ServicesProcol
    init(services: ServicesProcol = Services.shared) {
        self.services = services
    }

    func fetchByFilter(category: CustomFilterCategory) async throws -> MediaSection {
        let serie = try await self.services.fetch(endPoint: MediaEndpoint.serieWithFilter(MediaByCategoryParam.createForCategory(category, page: 1)), SerieListDTO.self)
        let list: SerieListTitleDTO = .init(id: category.idFromType(aditionalID: CustomFilterCategory.MediaIdType.serie.rawValue),
                                            name: category.nameSectionFromType())
        return SerieListDomainMapper(list: list).mapValue(response: serie)
    }

    func fetchGenres() async throws -> [MediaSection] {
        let genresList = try await services.fetch(endPoint: MediaEndpoint.serieGenres, GenreListDTO.self)
        typealias SerieList = (GenreDTO, SerieListDTO)

        let genres = try await withThrowingTaskGroup(of: SerieList.self) { group -> [SerieList] in
            for genre in Array(genresList.genres).sorted(by: { $0.id < $1.id })[0..<2] {
                group.addTask {
                    let movie = try await self.services.fetch(endPoint: MediaEndpoint.serieWithFilter(MediaWithGenreParam(withGenres: genre.id, page: 1)), SerieListDTO.self)
                    return (genre, movie)
                }
            }

            var results: [SerieList] = []

            for try await movieList in group {
                results.append(movieList)
            }
            return results
        }

        return genres.map { (genre, list) in
            SerieListDomainMapper(list: genre).mapValue(response: list)
        }
    }


}
