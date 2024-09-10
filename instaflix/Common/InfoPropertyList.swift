//
//  InfoPropertyList.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 6/09/24.
//

import Foundation

struct InfoPropertyList {
    enum Key: String {
        case api = "API_Key"
        case apiRead = "APIREAD_KEY"
        case urlBase = "URL_BASE"
        case imageBaseUrl = "IMAGE_BASE_URL"
    }

    static func getBy(key: Key) -> String? {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String else {
            return nil
        }

        return apiKey
    }
}
