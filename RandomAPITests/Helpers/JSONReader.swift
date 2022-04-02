//
//  JSONReader.swift
//  RandomAPITests
//
//  Created by Random Inc. on 2/4/22.
//

import Foundation

struct JSONReader {
    let content: String
    let contentData: Data

    init(fileName: String, anyClass: AnyClass) throws {
        guard let path = Bundle(for: anyClass).path(forResource: fileName, ofType: "json") else {
            fatalError("Can't find json file")
        }

        let jsonString = try String(contentsOfFile: path, encoding: .utf8)
        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Can not serialize to json data")
        }

        content = jsonString
        contentData = jsonData
    }
}
