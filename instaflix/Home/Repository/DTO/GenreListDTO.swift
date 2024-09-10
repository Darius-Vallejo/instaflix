//
//  GenreListDTO.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 7/09/24.
//

import Foundation

struct GenreListDTO: Decodable {
    let genres: Set<GenreDTO>
}

struct GenreDTO: MediaListTitle, Decodable, Hashable {
    let id: Int
    let name: String
}
