//
//  Results.swift
//  RandomAPI
//
//  Created by Random Inc. on 2/4/22.
//

import Foundation

// MARK: - Result

public struct Result: Codable, Equatable {
    let gender: Gender
    public let name: Name
    let location: Location
    public let email: String
    public let login: Login
    let dob, registered: Dob
    public let phone, cell: String
    let id: ID
    public let picture: Picture
    let nat: String
}

// MARK: - Dob

struct Dob: Codable, Equatable {
    let date: String
    let age: Int
}

enum Gender: String, Codable, Equatable {
    case female
    case male
}

// MARK: - ID

struct ID: Codable, Equatable {
    let name: String
    let value: String?
}

// MARK: - Login

public struct Login: Codable, Equatable {
    public let uuid: String
    let username, password, salt: String
    let md5, sha1, sha256: String
}

// MARK: - Name

public struct Name: Codable, Equatable {
    public let first, last: String
}

// MARK: - Picture

public struct Picture: Codable, Equatable {
    let large, medium, thumbnail: String
}
