//
//  SerieDTO.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 8/09/24.
//

import Foundation


struct SerieListDTO: Decodable {
    let page: Int
    let results: [SerieDTO]
}

struct SerieListTitleDTO: MediaListTitle {
    var id: Int
    var name: String
}

struct SerieDTO: Decodable {
    var id: Int
    var name: String
    var originalLanguage: String
    var posterPath: String?
    var backdropPath: String?
    var overview: String
}
