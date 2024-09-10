//
//  TokenInterceptor.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 8/09/24.
//

import Foundation
import Alamofire

protocol TokenInterceptorProtocol {
    func getInterceptor(endpoint: EndpointBase, accessToken: String) -> RequestInterceptor?
    func getAccessToken() -> String
}

extension Services: TokenInterceptorProtocol {
    func getInterceptor(endpoint: EndpointBase, accessToken: String) -> RequestInterceptor? {
        var interceptor: RequestInterceptor?

        let authenticator = InterceptorAuthenticator()
        let credentials = InterceptorAuthCredential(token: accessToken)
        interceptor = AuthenticationInterceptor(
            authenticator: authenticator,
            credential: credentials)
        return interceptor
    }

    func getAccessToken() -> String {
        let apiKey = InfoPropertyList.getBy(key: .apiRead) ?? ""
        return apiKey
    }
}
