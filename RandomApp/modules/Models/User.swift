//
//  User.swift
//  RandomApp
//
//  Created by Random Inc. on 3/4/22.
//

import Foundation
import SwiftUI

struct User: Equatable {
    let id = UUID()
    let fullName: String
    let picture: Image
    let email: String
    let phone: String
}
