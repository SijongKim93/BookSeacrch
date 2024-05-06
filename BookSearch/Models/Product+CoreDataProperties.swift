//
//  Product+CoreDataProperties.swift
//  BookSearch
//
//  Created by 김시종 on 5/6/24.
//
//

import Foundation
import CoreData


extension BookList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookList> {
        return NSFetchRequest<BookList>(entityName: "Product")
    }

    @NSManaged public var title: String?
    @NSManaged public var authors: String?
    @NSManaged public var price: Int64

}

extension Product : Identifiable {

}
