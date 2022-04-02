//
//  Location.swift
//  RandomAPI
//
//  Created by Random Inc. on 2/4/22.
//

import Foundation

// MARK: - Location

struct Location: Codable, Equatable {
    let street: StreetOptions
    let city: String
    let state: String
    let country: String?
    let postcode: Postcode
    let coordinates: Coordinates
    let timezone: Timezone
}

// MARK: - Coordinates

struct Coordinates: Codable, Equatable {
    let latitude, longitude: String
}

// MARK: - Postcode

enum Postcode: Codable, Equatable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let content = try? container.decode(Int.self) {
            self = .integer(content)
            return
        }
        if let content = try? container.decode(String.self) {
            self = .string(content)
            return
        }
        throw DecodingError.typeMismatch(Postcode.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Postcode"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .integer(content):
            try container.encode(content)
        case let .string(content):
            try container.encode(content)
        }
    }

    static func == (lhs: Postcode, rhs: Postcode) -> Bool {
        switch (lhs, rhs) {
        case let (.string(lhsContent), .string(rhsContent)):
            return lhsContent == rhsContent
        case let (.integer(lhsContent), .integer(rhsContent)):
            return lhsContent == rhsContent
        default:
            return false
        }
    }
}

// MARK: - StreetOptions

enum StreetOptions: Codable, Equatable {
    case string(String)
    case street(Street)

    // MARK: - Street

    struct Street: Codable, Equatable {
        let number: Int
        let name: String
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let content = try? container.decode(String.self) {
            self = .string(content)
            return
        }
        if let content = try? container.decode(Street.self) {
            self = .street(content)
            return
        }
        throw DecodingError.typeMismatch(Postcode.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Postcode"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .string(model):
            try container.encode(model)
        case let .street(model):
            try container.encode(model)
        }
    }

    static func == (lhs: StreetOptions, rhs: StreetOptions) -> Bool {
        switch (lhs, rhs) {
        case let (.string(lhsContent), .string(rhsContent)):
            return lhsContent == rhsContent
        case let (.street(lhsContent), .street(rhsContent)):
            return lhsContent == rhsContent
        default:
            return false
        }
    }
}

// MARK: - Timezone

struct Timezone: Codable, Equatable {
    let offset, timezoneDescription: String

    enum CodingKeys: String, CodingKey {
        case offset
        case timezoneDescription = "description"
    }
}
