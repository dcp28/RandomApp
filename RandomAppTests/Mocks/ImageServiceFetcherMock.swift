//
//  ImageServiceFetcherMock.swift
//  RandomAppTests
//
//  Created by Random Inc. on 5/4/22.
//

import Foundation
@testable import RandomApp

final class ImageServiceFetcherMock: ServiceImageFetchable {
    var spyGetImage = Spy<URL>()
    var stubGetImage: Data = .init()

    func getImage(from url: URL) async throws -> Data {
        spyGetImage.setCalled()
        spyGetImage.calledWithArgs = url
        return stubGetImage
    }
}
