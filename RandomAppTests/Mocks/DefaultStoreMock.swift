//
//  DefaultStoreMock.swift
//  RandomAppTests
//
//  Created by Random Inc. on 5/4/22.
//

import Foundation
@testable import RandomApp

enum DefaultStoreMockError: Error {
    case elementNotStored
}

final class DefaultStoreMock: Storable {
    var spySaveElement = Spy<(Data, URL)>()
    var stubStoredElement: Data?

    func saveElement(element: Data, to url: URL) throws {
        spySaveElement.setCalled()
        spySaveElement.calledWithArgs = (element, url)
        stubStoredElement = element
    }

    func loadElement(from _: URL) throws -> Data {
        guard let stubStoredElement = stubStoredElement else {
            throw DefaultStoreMockError.elementNotStored
        }

        return stubStoredElement
    }
}
