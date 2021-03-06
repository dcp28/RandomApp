//
//  EnvironmentProtocol.swift
//  RandomAPI
//
//  Created by Random Inc. on 2/4/22.
//

import Foundation

public protocol EnvironmentProtocol {
    var baseURL: String { get }
}

struct RandomAPIEnvironment: EnvironmentProtocol {
    let baseURL: String
    init(environment: RandomAPIEnvironments) {
        baseURL = environment.rawValue
    }
}

public enum RandomAPIEnvironments: String {
    case pro = "https://randomuser.me"
}
