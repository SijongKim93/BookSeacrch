//
//  RecentlyBookInfo.swift
//  BookSearch
//
//  Created by 김시종 on 5/8/24.
//

import UIKit

// MARK: - 최근 본 책 데이터 모델링
struct RecentlyBookInfo {
    let title: String
    let thumbnail: String
    let authors: [String]
    let price: Int
    let contents: String
    
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
