//
//  Location.swift
//  RandomAPI
//
//  Created by Random Inc. on 2/4/22.
//

import Foundation

// MARK: - Location

public struct Location: Codable, Equatable {
    public let street: StreetOptions
    public let city: String
    public let state: String
    public let country: String?
    public let postcode: Postcode
    public let coordinates: Coordinates
    public let timezone: Timezone
}

// MARK: - Coordinates

public struct Coordinates: Codable, Equatable {
    public let latitude, longitude: String
}

// MARK: - Postcode

public enum Postcode: Codable, Equatable {
    case integer(Int)
    case string(String)

    public init(from decoder: Decoder) throws {
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

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .integer(content):
            try container.encode(content)
        case let .string(content):
            try container.encode(content)
        }
    }

    public static func == (lhs: Postcode, rhs: Postcode) -> Bool {
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

public enum StreetOptions: Codable, Equatable {
    case string(String)
    case street(Street)

    // MARK: - Street

    public struct Street: Codable, Equatable {
        public let number: Int
        public let name: String
    }

    public init(from decoder: Decoder) throws {
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

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .string(model):
            try container.encode(model)
        case let .street(model):
            try container.encode(model)
        }
    }

    public static func == (lhs: StreetOptions, rhs: StreetOptions) -> Bool {
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

public struct Timezone: Codable, Equatable {
    public let offset, timezoneDescription: String

    enum CodingKeys: String, CodingKey {
        case offset
        case timezoneDescription = "description"
    }
}
