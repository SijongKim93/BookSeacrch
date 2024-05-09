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
    
    var isEnd = false
    let pageSize = 40
    var page = 1
    
    func fetchBookData(withQuery query: String, page: Int, completion: @escaping (Result<BookData, Error>) -> Void) {
        let url = "https://dapi.kakao.com/v3/search/book"
        let headers: HTTPHeaders = ["Authorization": "KakaoAK 5aceac1423e03e3ca7f40477c827460d"]
        let parameters: [String: Any] = ["query": query, "size": pageSize, "page": page] // 페이지 번호 추가
        
        AF.request(url, parameters: parameters, headers: headers).responseData { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(BookData.self, from: data)
                    
                    let nextPageExists = decodedData.meta.isEnd
                    self.isEnd = !nextPageExists
                    
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





