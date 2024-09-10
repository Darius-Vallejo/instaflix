//
//  Media.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 7/09/24.
//

import Foundation

enum Language: String, Decodable {
    case en
    case fr
    case any
}

struct Media: Identifiable {
    var id: Int
    var originalLanguage: Language
    var originalTitle: String
    var title: String
    var posterPath: MediaPath
    var backdropPath: MediaPath
    var overview: String
}

struct MediaSection: Identifiable {
    enum TypeSection: String {
        case movie
        case serie
    }

    let id: Int
    var title: String
    var page: Int
    var type: TypeSection
    var list: [Media]
}

struct MediaPath {
    static let imageSize = "w300"
    var value: String

    var relativeURL: String {
        let base = Config.shared.imageBaseUrl
        return "\(base)/\(MediaPath.imageSize)\(value)"
    }
}

