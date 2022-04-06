//
//  UserCD+CoreDataProperties.swift
//  RandomApp
//
//  Created by Random Inc. on 6/4/22.
//
//

import CoreData
import Foundation

public extension UserCD {
    @nonobjc class func fetchRequest() -> NSFetchRequest<UserCD> {
        NSFetchRequest<UserCD>(entityName: "UserCD")
    }

    @NSManaged var email: String?
    @NSManaged var uuid: UUID?
    @NSManaged var phone: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var pictureMedium: URL?
    @NSManaged var pictureLarge: URL?
}

extension UserCD: Identifiable {}
