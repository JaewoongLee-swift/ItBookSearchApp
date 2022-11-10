//
//  ItBookAPI.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/10.
//

import Foundation

enum ItBookStoreError: Error {
    case requestFailError
    case jsonParsingError
}

//TODO: Unit Test 필요
final class ItBookStoreManager {
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func requestItBookStore (bookName: String, page: Int? = nil,completionHandler: @escaping (Result<ItBookStore, Error>) -> Void) {
        var url = "https://api.itbook.store/1.0/search/\(bookName)"
        if let page = page {
            url += "/\(page)"
        }
        
        guard let url = URL(string: url) else {
            return
        }
        
        let dataTask: URLSessionDataTaskProtocol = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            if let data = data,
               let response = response as? HTTPURLResponse,
               (200..<300) ~= response.statusCode {
                do {
                    let data = try JSONDecoder().decode(ItBookStore.self, from: data)
                    completionHandler(.success(data))
                } catch {
                    completionHandler(.failure(ItBookStoreError.jsonParsingError))
                }
            } else {
                completionHandler(.failure(ItBookStoreError.requestFailError))
            }
               
        }
        dataTask.resume()
        
    }
}
