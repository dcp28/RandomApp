//
//  BaseDBFetcher.swift
//  RandomApp
//
//  Created by Random Inc. on 7/4/22.
//

import CoreData
import Foundation

class BaseDBFetcher {
    private let viewContext: NSManagedObjectContext
    private let entityName: String

    init(viewContext: NSManagedObjectContext, entityName: String) {
        self.viewContext = viewContext
        self.entityName = entityName
    }

    func loadRangeOf<T: NSFetchRequestResult>(from lower: Int, to upper: Int) throws -> [T] {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
        fetchRequest.fetchOffset = lower
        fetchRequest.fetchLimit = upper
        let batch = try viewContext.fetch(fetchRequest)
        return batch
    }

    func isEntityEmpty<T: NSFetchRequestResult>(_ entity: T.Type) throws -> Bool {
        let entity: [T] = try loadRangeOf(from: 0, to: 1)
        return entity.isEmpty
    }
}
