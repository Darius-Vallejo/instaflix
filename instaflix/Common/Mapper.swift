//
//  Mapper.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 7/09/24.
//

import Foundation

protocol Mapper<T, U> {
    associatedtype T
    associatedtype U
    func mapValue(response: T) -> U
    func mapList(response: [T]) -> [U]
}

extension Mapper {
    func mapList(response: [T]) -> [U] {
        return response.compactMap({ mapValue(response: $0 )})
    }
}
