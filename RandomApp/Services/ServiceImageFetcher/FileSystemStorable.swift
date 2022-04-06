//
//  Storable.swift
//  RandomApp
//
//  Created by Random Inc. on 5/4/22.
//

import Foundation

protocol FileSystemStorable {
    func saveElement(element: Data, to: URL) throws
    func loadElement(from url: URL) throws -> Data
}

final class DefaultStore: FileSystemStorable {
    func saveElement(element: Data, to url: URL) throws {
        try element.write(to: url)
    }

    func loadElement(from url: URL) throws -> Data {
        try Data(contentsOf: url)
    }
}
