//
//  ServiceUserFetchable.swift
//  RandomApp
//
//  Created by Random Inc. on 3/4/22.
//

import Foundation
import RandomAPI

protocol ServiceUserFetchable {
    func getUsers() async throws -> [User]
}
