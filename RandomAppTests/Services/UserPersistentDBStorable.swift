//
//  PersitentDBStorerTests.swift
//  RandomAppTests
//
//  Created by Random Inc. on 7/4/22.
//

import CoreData
import Foundation
import RandomAPI
@testable import RandomApp
import XCTest

final class UserPersistentDBStorable: XCTestCase {
    var persistentDBStorer: UserPersistentDBStorer!

    override func setUp() {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(
            name: PersistenceDBStorerContainer.modelName
        )

        container.persistentStoreDescriptions = [persistentStoreDescription]

        container.loadPersistentStores(completionHandler: { _, error in
            guard let error = error else {
                return
            }

            fatalError("Can't load persistentStore due to \(error)")
        })

        persistentDBStorer = UserPersistentDBStorer(context: container)
    }

    func testLoadItemsMustReturnEmpty() throws {
        XCTAssertEqual(try persistentDBStorer.loadRangeOfUsers(from: 0, to: 10), [])
    }

    func testIsEntityEmptyMethod_returnsEmpty() throws {
        XCTAssertTrue(try persistentDBStorer.isEntityEmpty(UserCD.self))
    }

    func testSaveandLoadSomeElements() throws {
        let json = try JSONReader(fileName: "RandomUsers", anyClass: type(of: self))
        let results = try JSONDecoder().decode(RandomUserResponse.self, from: json.contentData).results

        try persistentDBStorer.saveUsers(results: results)

        let usersCD = try persistentDBStorer.loadRangeOfUsers(from: 0, to: 1)

        let userCD = usersCD[0]
        let result = results[0]

        XCTAssertEqual(userCD.uuid, UUID(uuidString: result.login.uuid))
        XCTAssertEqual(userCD.firstName, result.name.first)
        XCTAssertEqual(userCD.lastName, result.name.last)
        XCTAssertEqual(userCD.email, result.email)
        XCTAssertEqual(userCD.phone, result.phone)
        XCTAssertEqual(userCD.pictureLarge, URL(string: result.picture.large))
        XCTAssertEqual(userCD.pictureMedium, URL(string: result.picture.medium))
    }
}
