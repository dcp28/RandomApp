//
//  RandomAPIMock.swift
//  RandomApp
//
//  Created by Random Inc. on 5/4/22.
//

import Foundation
import RandomAPI

final class RandomAPIMock: RandomAPIProtocol {
    var spyFetchUsers = false
    var spyDownloadImage = Spy<URL>()
    var stubFetchUser: [Result] = []
    var stubDownloadImage: Data = .init()

    func fetchUsers() async throws -> [Result] {
        spyFetchUsers = true

        return stubFetchUser
    }

    func downloadImage(from _: URL) async throws -> Data {
        spyDownloadImage.setCalled()

        return stubDownloadImage
    }
}
