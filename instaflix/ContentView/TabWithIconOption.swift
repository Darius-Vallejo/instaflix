//
//  TabWithIconOption.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 6/09/24.
//

import Foundation

enum TabWithIconOption: String, CaseIterable {
    case home
    case search
    case comming
    case download
    case more

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .search:
            return "Search"
        case .comming:
            return "Comming Soon"
        case . download:
            return "Downloads"
        case .more:
            return "More"
        }
    }
}
