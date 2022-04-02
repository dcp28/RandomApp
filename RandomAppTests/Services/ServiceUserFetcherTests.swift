//
//  ServiceUserFetcherTests.swift
//  RandomAppTests
//
//  Created by Random Inc. on 5/4/22.
//

import Foundation
import RandomAPI
@testable import RandomApp
import XCTest

final class ServiceUserFetcherTests: XCTestCase {
    private let apiMock = RandomAPIMock()
    private let imageServiceFetcherMock = ImageServiceFetcherMock()
    private var results: [Result]? {
        guard let jsonReader = try? JSONReader(fileName: "RandomUsers", anyClass: type(of: self)) else {
            return nil
        }
        return try? JSONDecoder().decode(RandomUserResponse.self, from: jsonReader.contentData).results
    }

    func getDataImage(fileName: String) throws -> UIImage? {
        guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "jpeg", inDirectory: nil) else {
            fatalError("Can't find json file")
        }

        return UIImage(contentsOfFile: path)
    }

    func testFetchImageIsCalled_withTheExpectedURL() async throws {
        // MARK: Given

        apiMock.stubFetchUser = results ?? []

        let service = ServiceUserFetcher(apiService: apiMock, imageServiceFetcher: imageServiceFetcherMock)

        // MARK: When

        _ = try await service.getUsers()

        // MARK: Then

        XCTAssertEqual(imageServiceFetcherMock.spyGetImage.calledWithArgs, URL(string: results?.first?.picture.medium ?? "")!)
    }

    func testFetchusers_successFully() async throws {
        // MARK: Given

        let pixelsImgData = try getDataImage(fileName: "pixels")

        apiMock.stubFetchUser = results ?? []
        imageServiceFetcherMock.stubGetImage = pixelsImgData?.pngData() ?? Data()

        let service = ServiceUserFetcher(apiService: apiMock, imageServiceFetcher: imageServiceFetcherMock)

        // MARK: When

        let users = try await service.getUsers()

        // MARK: Then

        XCTAssertEqual(users.first?.fullName, "brad gibson")
        XCTAssertEqual(users.first?.email, "brad.gibson@example.com")
        XCTAssertEqual(users.first?.phone, "011-962-7516")
    }
}
