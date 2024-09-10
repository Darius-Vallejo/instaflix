//
//  CustomFilterCategory.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 9/09/24.
//

import Foundation

enum CustomFilterCategory {
    /// Add additional filters here
    case language(Language)
    case minVote(Int)

    func idFromType(aditionalID: Int) -> Int {
        switch self {
        case .language(.fr):
            return -500 + aditionalID
        case .language(.en):
            return -501 + aditionalID
        case .language(.any):
            return -502 + aditionalID
        case .minVote(let min):
            return -700 + aditionalID + min
        }
    }

    func nameSectionFromType() -> String {
        switch self {
        case .language(.fr):
            return "French"
        case .language(.en):
            return "English"
        case .language(.any):
            return "All"
        case .minVote(let min):
            return "Rated higher than \(min)"
        }
    }
}

extension CustomFilterCategory {
    enum MediaIdType: Int {
        case movie = 500
        case serie = 0
    }
}

struct CustomFilterCategoryAsyncSequence: AsyncSequence {
    typealias Element = CustomFilterCategory

    var categories: [CustomFilterCategory]

    init(_ categories: [CustomFilterCategory]) {
        self.categories = categories
    }

    func makeAsyncIterator() -> CustomFilterCategoryAsyncIterator {
        return CustomFilterCategoryAsyncIterator(self)
    }
}

struct CustomFilterCategoryAsyncIterator: AsyncIteratorProtocol {
    private var categories: [CustomFilterCategory]

    init(_ sequence: CustomFilterCategoryAsyncSequence) {
        self.categories = sequence.categories
    }

    mutating func next() async -> CustomFilterCategory? {
        guard !categories.isEmpty else {
            return nil
        }
        return categories.removeFirst()
    }
}

extension CustomFilterCategory: Hashable {}
