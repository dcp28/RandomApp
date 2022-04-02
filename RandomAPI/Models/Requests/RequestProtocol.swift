//
//  RequestProtocol.swift
//  RandomAPI
//
//  Created by Random Inc. on 2/4/22.
//

import Foundation

enum RequestMethod: String {
    /// HTTP GET
    case get = "GET"
}

enum RequestType {
    case data
}

typealias RequestParameters = [(key: String, value: Any)]

protocol RequestProtocol {
    var path: String? { get }
    var method: RequestMethod { get }
    var parameters: RequestParameters { get }
    var requestType: RequestType { get }
}
