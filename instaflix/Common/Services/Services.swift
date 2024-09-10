//
//  Services.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 7/09/24.
//

import Foundation
import Alamofire
import Combine

class Services {

    static let shared = Services()

    enum HeaderConstants: String {
        case auth = "Authorization"
        case bearer = "Bearer"
        case content = "Content-Type"
        case application = "application/json"
    }

    private static let timeoutInSeconds: TimeInterval = 30
    private static let configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = timeoutInSeconds
        return configuration
    }()

    public lazy var session: Session = {
        return Session(configuration: Services.configuration,
                       serverTrustManager: ServerTrustManager(allHostsMustBeEvaluated: false, evaluators: [:]))
    }()

    private init() {}
}

extension Services {
    func filterData<T>(_ output: DataResponsePublisher<T>.Output) throws -> Data {
        let defaultError = NetworkError.invalidResponse
        guard let httpResponse = output.response else {
            print("---> output \(output)")
            throw defaultError
        }

        switch output.result {
        case .success:
            guard let data = output.data else {
                throw defaultError
            }

            return data
        case .failure(let afError):
            let response = output.response
            let statusCode = response?.statusCode ?? 0
            let urlDescription = httpResponse.url?.description ?? "Unknown"

            print("[Request] \(urlDescription) [\(statusCode)] ERROR: \(afError) \(response?.description ?? "")")

            throw NetworkError.networkError(afError)
        }
    }
}
