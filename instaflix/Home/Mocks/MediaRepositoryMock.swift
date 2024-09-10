//
//  MediaRepositoryMock.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 8/09/24.
//

import Foundation

struct MediaRepositoryMock: MediaRepositoryProtocol {
    
    func fetchByFilter(category: CustomFilterCategory) async throws -> MediaSection {
        return .init(id: 1, title: "Otra", page: 1, type: .movie, list: [])
    }
    
    func fetchGenres() async throws -> [MediaSection] {
        let media: [Media] = [
            .init(id: 1,
                  originalLanguage: .en,
                  originalTitle: "movie 1",
                  title: "movie 1",
                  posterPath: .init(value: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg"),
                  backdropPath: .init(value: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg"),
                  overview: ""),
            .init(id: 2,
                  originalLanguage: .en,
                  originalTitle: "movie 2",
                  title: "movie 2",
                  posterPath: .init(value: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg"),
                  backdropPath: .init(value: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg"),
                  overview: "")
        ]
        return [
            .init(id: 1, title: "Drama", page: 1, type: .movie, list: media),
            .init(id: 2, title: "Drama", page: 1, type: .movie, list: media)
        ]
    }
}
