//
//  MediaEndpoint.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 7/09/24.
//

import Foundation

enum MediaEndpoint {
    case movieGenres
    case movieWithFilter(any Encodable)
    case serieGenres
    case serieWithFilter(any Encodable)
}

extension MediaEndpoint: EndpointBase {

    enum Constants: String {
        case get = "GET"
    }

    private var relativeURL: String {
        switch self {
        case .movieGenres:
            return "/genre/movie/list"
        case .movieWithFilter:
            return "/discover/movie"
        case .serieGenres:
            return "/genre/tv/list"
        case .serieWithFilter:
            return "/discover/tv"
        }
    }

    var urlString: String {
        let base = Config.shared.baseUrl
        return "\(base)\(relativeURL)"
    }
    
    var method: String {
        return Constants.get.rawValue
    }
    
    var parameters: [String: Any] {
        switch self {
        case .movieWithFilter(let params):
            return params.dictionary() ?? [:]
        case .serieWithFilter(let params):
            return params.dictionary() ?? [:]
        default:
            return [:]
        }
    }
    

}
