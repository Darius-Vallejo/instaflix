//
//  SerieDomainMapper.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 8/09/24.
//

import Foundation

struct SerieDomainMapper: Mapper {
    func mapValue(response: SerieDTO) -> Media {
        let language = Language(rawValue: response.originalLanguage)

        return .init(id: response.id,
                     originalLanguage: language ?? .any,
                     originalTitle: response.name,
                     title: response.name,
                     posterPath: .init(value: response.posterPath ?? ""),
                     backdropPath: .init(value: response.posterPath ?? ""),
                     overview: response.overview
        )
    }

}

protocol MediaListTitle {
    var id: Int { get }
    var name: String { get }
}

struct SerieListDomainMapper: Mapper {
    var list: MediaListTitle
    func mapValue(response: SerieListDTO) -> MediaSection {
        return .init(id: list.id,
                     title: list.name,
                     page: response.page,
                     type: .serie,
                     list: SerieDomainMapper().mapList(response: response.results))
    }
}
