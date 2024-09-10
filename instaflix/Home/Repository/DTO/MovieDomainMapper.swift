//
//  MovieDomainMapper.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 7/09/24.
//

import Foundation

struct MovieDomainMapper: Mapper {
    func mapValue(response: MovieDTO) -> Media {
        let language = Language(rawValue: response.originalLanguage)

        return .init(id: response.id,
                     originalLanguage: language ?? .any,
                     originalTitle: response.title,
                     title: response.title,
                     posterPath: .init(value: response.posterPath ?? ""),
                     backdropPath: .init(value: response.posterPath ?? ""), 
                     overview: response.overview
        )
    }

}

struct MovieListDomainMapper: Mapper {
    var list: MediaListTitle
    func mapValue(response: MovieListDTO) -> MediaSection {
        return .init(id: list.id,
                     title: list.name,
                     page: response.page,
                     type: .movie,
                     list: MovieDomainMapper().mapList(response: response.results))
    }
}
