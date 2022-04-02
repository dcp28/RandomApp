//
//  SessionHandlerMock.swift
//  RandomAPITests
//
//  Created by Random Inc. on 2/4/22.
//

import Foundation
@testable import RandomAPI

final class SessionHandlerMock: SessionHandler {
    var requestUrlSpy = Spy<URLRequest>()
    var requestStub = (Data(), URLResponse(
        url: URL(string: "http://default.com")!,
        mimeType: nil,
        expectedContentLength: 0,
        textEncodingName: nil
    ))

    func request(url: URLRequest) async throws -> (Data, URLResponse) {
        requestUrlSpy.setCalled()
        requestUrlSpy.calledWithArgs = url

        return requestStub
    }
}
