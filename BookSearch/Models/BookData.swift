//
//  BookData.swift
//  BookSearch
//
//  Created by 김시종 on 4/30/24.
//

import UIKit
import CoreData

// MARK: - BookData
struct BookData: Codable {
    let documents: [Document]
}

// MARK: - Document
struct Document: Codable {
    let authors: [String]
    let contents, datetime, isbn: String
    let price: Int
    let publisher: String
    let salePrice: Int
    let status: String
    let thumbnail: String
    let title: String
    let translators: [String]
    let url: String

    enum CodingKeys: String, CodingKey {
        case authors, contents, datetime, isbn, price, publisher
        case salePrice = "sale_price"
        case status, thumbnail, title, translators, url
    }
    
    func authorsToString() -> String {
        return authors.joined(separator: ", ")
    }
    
}



