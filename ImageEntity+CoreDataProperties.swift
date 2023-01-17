//
//  ImageEntity+CoreDataProperties.swift
//  CoreDataBootcamp
//
//  Created by Kanishk Vijaywargiya on 17/01/23.
//
//

import Foundation
import CoreData


extension ImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        return NSFetchRequest<ImageEntity>(entityName: "ImageEntity")
    }

    @NSManaged public var first_name: String?
    @NSManaged public var last_name: String?
    @NSManaged public var id: Int16
    @NSManaged public var avatar: String?

}

extension ImageEntity : Identifiable {

}
