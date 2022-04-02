//
//  Spy.swift
//  RandomAPITests
//
//  Created by Random Inc. on 2/4/22.
//

import Foundation

struct Spy<T> {
    var calledWithArgs: T?
    private(set) var isCalled = false

    mutating func setCalled() {
        isCalled = true
    }
}
