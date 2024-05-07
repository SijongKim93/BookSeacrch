//
//  Product+CoreDataProperties.swift
//  BookSearch
//
//  Created by 김시종 on 5/6/24.
//
//

import Foundation
import CoreData


extension BookCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookCoreData> {
        return NSFetchRequest<BookCoreData>(entityName: "BookCoreData")
    }

    @NSManaged public var title: String?
    @NSManaged public var authors: String?
    @NSManaged public var price: Int64

}

extension BookCoreData : Identifiable {

}
