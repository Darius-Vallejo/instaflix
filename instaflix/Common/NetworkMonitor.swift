//
//  NetworkMonitor.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 9/09/24.
//

import Network
import Combine

class NetworkMonitor {
    static var shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    var networkStatusPublisher = CurrentValueSubject<Bool, Never>(false)

    private init() {
        monitor.pathUpdateHandler = { path in
            let isConnected = path.status == .satisfied
            self.networkStatusPublisher.send(isConnected)
        }
        monitor.start(queue: queue)
    }
}
