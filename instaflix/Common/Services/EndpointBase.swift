//
//  EndpointBase.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 8/09/24.
//

import Foundation

protocol EndpointBase {
    var urlString: String { get }
    var method: String { get }
    var parameters: [String: Any] { get }
}
