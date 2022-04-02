//
//  ServiceImageFetchable.swift
//  RandomApp
//
//  Created by Random Inc. on 5/4/22.
//

import Foundation

protocol ServiceImageFetchable {
    func getImage(from url: URL) async throws -> Data
}
