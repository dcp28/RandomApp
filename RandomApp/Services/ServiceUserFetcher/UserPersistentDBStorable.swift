//
//  UserPersistentDBStorable.swift
//  RandomApp
//
//  Created by Random Inc. on 7/4/22.
//

import CoreData
import Foundation
import RandomAPI

protocol UserPersistentDBStorable {
    func saveUsers(results: [Result]) throws
    func loadRangeOfUsers(from lower: Int, to upper: Int) throws -> [UserCD]
    func isUsersEntityEmpty() throws -> Bool
}

enum PersistentDBStorableError: Error {
    case appDalegateNotLoaded
}

final class UserPersistentDBStorer: BaseDBFetcher, UserPersistentDBStorable {
    var viewContext: NSManagedObjectContext
    static let entityName = "UserCD"

    init(context: NSPersistentContainer) {
        viewContext = context.viewContext
        super.init(viewContext: context.viewContext, entityName: UserPersistentDBStorer.entityName)
    }

    func saveUsers(results: [Result]) throws {
        for result in results {
            guard let uuid = UUID(uuidString: result.login.uuid) else {
                print("Invalid uuid \(result.login.uuid)")
                continue
            }
            let newUser = UserCD(context: viewContext)
            newUser.uuid = uuid
            newUser.firstName = result.name.first
            newUser.lastName = result.name.last
            newUser.email = result.email
            newUser.phone = result.phone
            newUser.pictureMedium = URL(string: result.picture.medium)
            newUser.pictureLarge = URL(string: result.picture.large)
            try viewContext.save()
        }
    }

    func loadRangeOfUsers(from lower: Int, to upper: Int) throws -> [UserCD] {
        try loadRangeOf(from: lower, to: upper)
    }

    func isUsersEntityEmpty() throws -> Bool {
        try isEntityEmpty(UserCD.self)
    }
}
