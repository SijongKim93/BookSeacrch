//
//  NetworkingManager.swift
//  BookSearch
//
//  Created by 김시종 on 4/30/24.
//

import UIKit
import Alamofire
import Kingfisher


class NetworkingManager {
    
    static let shared = NetworkingManager()
    private init() {}
    
    
    func fetchBookData(withQuery query: String, completion: @escaping (Result<BookData, Error>) -> Void) {
        let url = "https://dapi.kakao.com/v3/search/book"
        let headers: HTTPHeaders = ["Authorization": "KakaoAK 5aceac1423e03e3ca7f40477c827460d"]
        let parameters: [String: String] = ["query": query, "size": "40"]
        
        AF.request(url, parameters: parameters, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                print("Received data from network request:")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(BookData.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}





