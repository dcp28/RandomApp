//
//  RandomUsersRequest.swift
//  RandomAPI
//
//  Created by Random Inc. on 2/4/22.
//

import Foundation

struct RandomUserRequest: RequestProtocol {
    let path: String? = "/api/"
    let method: RequestMethod = .get
    let parameters: RequestParameters = [("results", 40)]
    let requestType: RequestType = .data
}
