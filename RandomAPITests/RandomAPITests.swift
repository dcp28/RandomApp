//
//  RandomAPITests.swift
//  RandomAPITests
//
//  Created by Random Inc. on 2/4/22.
//

import Foundation
@testable import RandomAPI
import XCTest

final class RandomAPITests: XCTestCase {
    private let sessionMock = SessionHandlerMock()
    private let urlResponse = URLResponse(
        url: URL(string: "http://empty.com")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil
    )

    private var randomAPI: RandomAPI!
    var randomUserResponse: Data!

    override func setUpWithError() throws {
        randomAPI = RandomAPI(environment: .pro, sessionHandler: sessionMock)
        randomUserResponse = try JSONReader(fileName: "RandomUsers", anyClass: type(of: self)).contentData
        sessionMock.requestStub = (randomUserResponse, urlResponse)
    }

    func testWhenFetchUsers_failsDueToInvalidDecode() async {
        // MARK: Given

        sessionMock.requestStub = (Data(), urlResponse)

        // MARK: When

        do {
            _ = try await randomAPI.fetchUsers()
        } catch is DecodingError {
            return
        } catch {
            XCTFail("Must fail as decoding error")
        }

        XCTFail("Must fail")
    }

    func testWhenFetchUsers_URLRequestIsBuildAsExpected() async throws {
        // MARK: When

        _ = try await randomAPI.fetchUsers()

        // MARK: Then

        XCTAssertEqual(
            sessionMock.requestUrlSpy.calledWithArgs,
            URLRequest(url: URL(string: RandomAPIEnvironments.pro.rawValue + "/api/?results=40")!)
        )
    }

    func testWhenFetchUsers_ReturnsUserResults() async throws {
        // MARK: Given

        let expectedResults = try JSONDecoder().decode(RandomUserResponse.self, from: randomUserResponse)

        // MARK: When

        let results = try await randomAPI.fetchUsers()

        // MARK: Then

        XCTAssertEqual(results, expectedResults.results)
    }

    func testWhenFetchUsers_mustFilterRepeatedOnes() async throws {
        // MARK: Given

        let data = try JSONReader(fileName: "RepeatedRandomUsers", anyClass: type(of: self)).contentData
        sessionMock.requestStub = (data, urlResponse)

        // MARK: When

        let results = try await randomAPI.fetchUsers()

        // MARK: Then

        XCTAssertEqual(results.count, 1)
    }

    func testFetchUsers_failsWithBadResponse() async throws {
        // MARK: Given

        let httpResponse = HTTPURLResponse(
            url: URL(string: "http://bad.com")!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil
        )

        sessionMock.requestStub = (Data(), httpResponse!)

        // MARK: When

        do {
            _ = try await randomAPI.fetchUsers()
        } catch {
            if let error = error as? RandomAPIError {
                XCTAssertTrue(error == .badResponse(code: 400))
                return
            }
        }

        XCTFail("Must fail with badResponse")
    }

    func testDownloadImage_successFully() async throws {
        // MARK: Given

        let expectedData = "hello".data(using: .utf8)!
        sessionMock.requestStub = (expectedData, urlResponse)

        // MARK: When

        let imagePath: Data = try await randomAPI.downloadImage(from: URL(string: "https://image.com/downloads/img.jpg")!)

        // MARK: Then

        XCTAssertEqual(imagePath, expectedData)
    }

    func testDownloadImage_failsWithBadResponse() async throws {
        // MARK: Given

        let httpResponse = HTTPURLResponse(
            url: URL(string: "http://bad.com")!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil
        )

        sessionMock.requestStub = (Data(), httpResponse!)

        // MARK: When

        do {
            _ = try await randomAPI.downloadImage(from: URL(string: "hi")!)
        } catch {
            if let error = error as? RandomAPIError {
                XCTAssertTrue(error == .badResponse(code: 400))
                return
            }
        }

        XCTFail("Must fail with badResponse")
    }
}
