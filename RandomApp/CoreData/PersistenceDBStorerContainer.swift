//
//  PersistenceDBStorerContainer.swift
//  RandomApp
//
//  Created by Random Inc. on 6/4/22.
//

import CoreData
import Foundation
import RandomAPI

final class PersistenceDBStorerContainer {
    static let modelName = "UserAppModel"
    let context = NSPersistentContainer(name: PersistenceDBStorerContainer.modelName)
    static let shared = PersistenceDBStorerContainer()

    private init() {
        context.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError("Core data can't be laoded \(error)")
            }
        })
    }
}
