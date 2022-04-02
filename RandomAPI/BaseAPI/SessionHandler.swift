//
//  SessionHandler.swift
//  RandomAPI
//
//  Created by Random Inc. on 2/4/22.
//

import Foundation

public protocol SessionHandler {
    func request(url: URLRequest) async throws -> (Data, URLResponse)
}

public struct SessionHandlerImpl: SessionHandler {
    private let urlSession: URLSession

    public init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    public func request(url: URLRequest) async throws -> (Data, URLResponse) {
        try await urlSession.data(for: url)
    }
}
