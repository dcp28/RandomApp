//
//  SessionHandlerMock.swift
//  RandomAPITests
//
//  Created by Random Inc. on 2/4/22.
//

import Foundation
@testable import RandomAPI

final class SessionHandlerMock: SessionHandler {
    private static let urlResponse = URLResponse(
        url: URL(string: "http://default.com")!,
        mimeType: nil,
        expectedContentLength: 0,
        textEncodingName: nil
    )
    var requestUrlSpy = Spy<URLRequest>()
    var requestStub = (Data(), SessionHandlerMock.urlResponse)

    var downloadStub = (URL(string: "http://default.com")!, SessionHandlerMock.urlResponse)

    func request(url: URLRequest) async throws -> (Data, URLResponse) {
        requestUrlSpy.setCalled()
        requestUrlSpy.calledWithArgs = url

        return requestStub
    }
}
