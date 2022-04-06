//
//  ServiceUserFetcher.swift
//  RandomApp
//
//  Created by Random Inc. on 6/4/22.
//

import Foundation
import RandomAPI
import SwiftUI

enum ServiceUserFetcherError: Error {
    case failingWhenHashingURL
    case notURLConvertible
    case unknown
}

class ServiceUserFetcher: ServiceUserFetchable {
    private let apiService: RandomAPIProtocol
    private let imageServiceFetcher: ServiceImageFetchable
    private let store: UserPersistentDBStorable

    init(
        apiService: RandomAPIProtocol,
        imageServiceFetcher: ServiceImageFetchable,
        store: UserPersistentDBStorable
    ) {
        self.apiService = apiService
        self.imageServiceFetcher = imageServiceFetcher
        self.store = store
    }

    func getUsers() async throws -> [User] {
        let results = try await apiService.fetchUsers()

        var users: [User] = []

        if try store.isUsersEntityEmpty() {
            print("Local storage is emnpty")
            try store.saveUsers(results: results)
        }

        let userCDS = try store.loadRangeOfUsers(from: 0, to: 10)

        for userCD in userCDS {
            await users.append(getUser(from: userCD))
        }

        return users
    }

    private func getUser(from userCD: UserCD) async -> User {
        let image: Image

        if let imgURL = userCD.pictureMedium, let data = try? await imageServiceFetcher.getImage(from: imgURL), let uiImage = UIImage(data: data) {
            image = Image(uiImage: uiImage)
        } else {
            image = Image("slenderman")
        }

        return User(
            fullName: "\(userCD.firstName ?? "Slenderman") \(userCD.lastName ?? "")",
            picture: image,
            email: userCD.email ?? "slenderman@example.com",
            phone: userCD.phone ?? "123456"
        )
    }
}
