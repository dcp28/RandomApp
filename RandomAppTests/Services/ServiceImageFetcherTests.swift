//
//  ServiceImageFetcherTests.swift
//  RandomAppTests
//
//  Created by Random Inc. on 5/4/22.
//

import Foundation
@testable import RandomApp
import XCTest

final class ServiceImageFetcherTests: XCTestCase {
    var randomAPIMock = RandomAPIMock()
    var storeMock = DefaultStoreMock()
    var service: ServiceImageFetcher!
    let expectedData = "hello".data(using: .utf8)!

    override func setUp() {
        service = ServiceImageFetcher(apiService: randomAPIMock, store: storeMock)
    }

    func testIfImageNotExist_fetchItAndStoreOnTheFileSystem() async {
        // MARK: Given

        randomAPIMock.stubDownloadImage = expectedData

        // MARK: When

        _ = try? await service.getImage(from: URL(string: "file-name")!)

        XCTAssertTrue(randomAPIMock.spyDownloadImage.isCalled)
        XCTAssertTrue(storeMock.spySaveElement.isCalled)

        XCTAssertEqual(storeMock.spySaveElement.calledWithArgs?.0, expectedData)
    }

    func testIfImageAlreadyExists_dontFetchData() async throws {
        // MARK: Given

        storeMock.stubStoredElement = expectedData

        // MARK: When

        let data = try await service.getImage(from: URL(string: "file-name")!)

        XCTAssertFalse(randomAPIMock.spyDownloadImage.isCalled)
        XCTAssertFalse(storeMock.spySaveElement.isCalled)

        XCTAssertEqual(data, expectedData)
    }
}
