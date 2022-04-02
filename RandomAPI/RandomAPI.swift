//
//  APIRequestDispacher.swift
//  RandomAPI
//
//  Created by Random Inc. on 2/4/22.
//

import Foundation

public protocol RandomAPIProtocol {
    func fetchUsers() async throws -> [Result]
    func downloadImage(from url: URL) async throws -> Data
}

enum RandomAPIError: Error, Equatable {
    case badResponse(code: Int)
}

public class RandomAPI: RandomAPIProtocol {
    private let sessionHandler: SessionHandler
    private let environment: EnvironmentProtocol
    private let jsonDecoder = JSONDecoder()

    public init(
        environment: RandomAPIEnvironments,
        sessionHandler: SessionHandler = SessionHandlerImpl(urlSession: URLSession.shared)
    ) {
        self.sessionHandler = sessionHandler
        self.environment = RandomAPIEnvironment(environment: environment)
    }

    public func fetchUsers() async throws -> [Result] {
        let baseOperation = BaseAPIOperation(
            environment: environment, request: RandomUserRequest()
        )

        switch try await baseOperation.execute(session: sessionHandler) {
        case let .json(data, response):
            try handleResponse(response)
            return (try convertToModel(data: data) as RandomUserResponse).results.filterRepeatedUsers()
        }
    }

    private func convertToModel<T: Decodable>(data: Data) throws -> T {
        try jsonDecoder.decode(T.self, from: data)
    }

    public func downloadImage(from url: URL) async throws -> Data {
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await sessionHandler.request(url: urlRequest)
        try handleResponse(response)
        return data
    }

    private func handleResponse(_ response: URLResponse) throws {
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 200 ... 299:
                break
            default:
                throw RandomAPIError.badResponse(code: response.statusCode)
            }
        }
    }
}
