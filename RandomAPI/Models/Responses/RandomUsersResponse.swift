//
//  RandomUserResponse.swift
//  RandomAPI
//
//  Created by Random Inc. on 2/4/22.
//

import Foundation

// MARK: - RandomUserResponse

struct RandomUserResponse: Codable, Equatable {
    let results: [Result]
    let info: Info
}

// MARK: - Info

struct Info: Codable, Equatable {
    let seed: String
    let results, page: Int
    let version: String
}
