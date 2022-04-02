//
//  BaseAPIOperationTests.swift
//  RandomAPITests
//
//  Created by Random Inc. on 2/4/22.
//

import Foundation
@testable import RandomAPI
import XCTest

final class BaseAPIOperationTests: XCTestCase {
    private let sessionMock = SessionHandlerMock()
    private var baseAPIOperation: BaseAPIOperation!

    struct EnvironmentTest: EnvironmentProtocol {
        let baseURL: String = "http://base-url.com"
    }

    struct RequestProtocolTest: RequestProtocol {
        let path: String?
        let method: RequestMethod = .get
        let parameters: RequestParameters = [("query", 40)]
        let requestType: RequestType = .data

        init(path: String?) {
            self.path = path
        }
    }

    override func setUp() {
        super.setUp()
    }

    func testSuccessRequestWithPathNil() async throws {
        let request = RequestProtocolTest(path: nil)
        baseAPIOperation = BaseAPIOperation(environment: EnvironmentTest(), request: request)

        _ = try await baseAPIOperation.execute(session: sessionMock)

        XCTAssertTrue(sessionMock.requestUrlSpy.isCalled)
        XCTAssertEqual(sessionMock.requestUrlSpy.calledWithArgs, URLRequest(url: URL(string: "http://base-url.com?query=40")!))
    }

    func testSuccessRequestWithPathNotNil() async throws {
        let request = RequestProtocolTest(path: "/path")
        baseAPIOperation = BaseAPIOperation(environment: EnvironmentTest(), request: request)

        _ = try await baseAPIOperation.execute(session: sessionMock)

        XCTAssertTrue(sessionMock.requestUrlSpy.isCalled)
        XCTAssertEqual(sessionMock.requestUrlSpy.calledWithArgs, URLRequest(url: URL(string: "http://base-url.com/path?query=40")!))
    }

    func testFailDueToInvalidPath() async throws {
        let request = RequestProtocolTest(path: "path")
        baseAPIOperation = BaseAPIOperation(environment: EnvironmentTest(), request: request)

        do {
            _ = try await baseAPIOperation.execute(session: sessionMock)
        } catch {
            return
        }

        XCTFail("Must fail")
    }
}
