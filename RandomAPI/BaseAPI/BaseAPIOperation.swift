//
//  BaseAPIOperation.swift
//  RandomAPI
//
//  Created by Random Inc. on 2/4/22.
//

import Foundation

enum OperationResult {
    case json(_: Data, _: URLResponse)
}

class BaseAPIOperation {
    private let environment: EnvironmentProtocol
    private let request: RequestProtocol

    public init(environment: EnvironmentProtocol, request: RequestProtocol) {
        self.environment = environment
        self.request = request
    }

    func execute(session: SessionHandler) async throws -> OperationResult {
        try await internalExecute(session: session)
    }

    private func internalExecute(session: SessionHandler) async throws -> OperationResult {
        switch request.requestType {
        case .data:
            let (data, response) = try await session.request(url: try getURLRequest())
            return .json(data, response)
        }
    }

    private func getURLRequest() throws -> URLRequest {
        let components = try getURLComponents()

        guard let url = components.url else {
            throw APIRequestError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        return urlRequest
    }

    private func getURLComponents() throws -> URLComponents {
        guard var components = URLComponents(string: environment.baseURL) else {
            throw APIRequestError.invalidBaseURL
        }

        if let path = request.path {
            components.path = path
        }
        components.queryItems = request.parameters.map { element in
            URLQueryItem(name: element.key, value: "\(element.value)")
        }

        return components
    }
}
