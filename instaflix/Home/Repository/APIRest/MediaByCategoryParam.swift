//
//  MediaByCategoryParam.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 8/09/24.
//

import Foundation

struct MediaByCategoryParam: Encodable {
    var originalLanguage: String?
    var page: Int
    var sortBy: String = "popularity.desc"
    var voteAverageGt: Int?
    
    init(originalLanguage: String? = nil, voteAverageGt: Int? = nil, page: Int) {
        self.originalLanguage = originalLanguage
        self.voteAverageGt = voteAverageGt
        self.page = page
    }

    enum CodingKeys: String, CodingKey {
        case originalLanguage = "with_original_language"
        case page
        case sortBy = "sort_by"
        case voteAverageGt = "vote_average.gte"
    }

    static func createForCategory(_ category: CustomFilterCategory, page: Int) -> MediaByCategoryParam {
        switch category {
        case .language(let language):
            return .init(originalLanguage: language.rawValue, page: page)
        case .minVote(let vote):
            return .init(voteAverageGt: vote, page: page)
        }
    }
}



