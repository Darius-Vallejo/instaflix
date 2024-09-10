//
//  ServicesProcol.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 8/09/24.
//

import Foundation
import Alamofire
import Combine

protocol ServicesProcol {
    func fetch<M: Decodable>(endPoint: EndpointBase, _ type: M.Type) async throws -> M
}

extension Services: ServicesProcol {
    func fetch<M>(endPoint: EndpointBase, _ type: M.Type) async throws -> M where M : Decodable {
        var cancelable: Cancellable?
            return try await withCheckedThrowingContinuation { continuation in
                var headers = HTTPHeaders()
                headers.add(name: HeaderConstants.content.rawValue, value: HeaderConstants.application.rawValue)
                let method = HTTPMethod(rawValue: endPoint.method)

                print("--> EXECUTING \(endPoint.urlString)")
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                cancelable = session.request(endPoint.urlString,
                                       method: method,
                                       parameters: endPoint.parameters,
                                       headers: headers,
                                       interceptor: getInterceptor(endpoint: endPoint, accessToken: getAccessToken())
                )
                .publishDecodable(type: M.self, decoder: decoder)
                .tryMap {
                    try self.filterData($0)
                }
                .decode(type: M.self, decoder: decoder)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print("ERROR: \(error)")
                        continuation.resume(throwing: NetworkError.unknownError(error))
                        cancelable?.cancel()
                    case .finished:
                        print("\(endPoint.urlString) - SUCCESS")
                        break
                    }
                } receiveValue: { response in
                    continuation.resume(returning: response)
                    cancelable?.cancel()
                }
            }
    }
}
