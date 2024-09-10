//
//  Config.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 7/09/24.
//

import Foundation

struct Config {

    static var shared: Config = .init()

    lazy var baseUrl: String = {
        return InfoPropertyList.getBy(key: .urlBase) ?? ""
    }()

    lazy var imageBaseUrl: String = {
        return InfoPropertyList.getBy(key: .imageBaseUrl) ?? ""
    }()

    private init() {}
}
