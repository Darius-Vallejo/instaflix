//
//  MovieDTO.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 7/09/24.
//

import Foundation

struct MovieListDTO: Decodable {
    let page: Int
    let results: [MovieDTO]
}

struct MovieDTO: Decodable {
    var id: Int
    var originalLanguage: String
    var originalTitle: String
    var title: String
    var posterPath: String?
    var backdropPath: String?
    var overview: String
}
