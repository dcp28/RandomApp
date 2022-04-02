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

    init(
        apiService: RandomAPIProtocol,
        imageServiceFetcher: ServiceImageFetchable
    ) {
        self.apiService = apiService
        self.imageServiceFetcher = imageServiceFetcher
    }

    func getUsers() async throws -> [User] {
        let results = try await apiService.fetchUsers()

        var users: [User] = []
        for result in results {
            let data = try await imageServiceFetcher.getImage(from: URL(string: result.picture.medium)!)

            let image: Image
            if let uiImage = UIImage(data: data) {
                image = Image(uiImage: uiImage)
            } else {
                image = Image("slenderman")
            }

            users.append(
                User(
                    fullName: result.name.first + " " + result.name.last,
                    picture: image,
                    email: result.email,
                    phone: result.phone
                )
            )
        }

        return users
    }
}
