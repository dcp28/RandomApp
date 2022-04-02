//
//  APIRequestDispacher.swift
//  RandomAPI
//
//  Created by Random Inc. on 2/4/22.
//

import Foundation

public protocol RandomAPIProtocol {
    func fetchUsers() async throws -> [Result]
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
        self.environment = RandomAPIEnvironment(enviroment: environment)
    }

    public func fetchUsers() async throws -> [Result] {
        let baseOperation = BaseAPIOperation(
            environment: environment, request: RandomUserRequest()
        )

        switch try await baseOperation.execute(session: sessionHandler) {
        case let .json(data, _):
            return (try convertToModel(data: data) as RandomUserResponse).results.filterRepeatedUsers()
        }
    }

    private func convertToModel<T: Decodable>(data: Data) throws -> T {
        try jsonDecoder.decode(T.self, from: data)
    }
}
