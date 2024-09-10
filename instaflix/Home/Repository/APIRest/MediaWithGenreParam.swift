//
//  MediaWithGenreParam.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 7/09/24.
//

import Foundation

struct MediaWithGenreParam: Encodable {
    var withGenres: Int
    var page: Int
    var sortBy: String = "popularity.desc"
    init(withGenres: Int, page: Int) {
        self.withGenres = withGenres
        self.page = page
    }
}
