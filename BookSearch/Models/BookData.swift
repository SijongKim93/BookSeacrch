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
    var documents: [Document]
    let meta: Meta
    
}

// MARK: - Meta
struct Meta: Codable {
    let isEnd: Bool
    let pageableCount, totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
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
    
    func formattedPrice() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) ?? ""
        return "\(formattedPrice)원"
    }
}



